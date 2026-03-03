FROM --platform=$BUILDPLATFORM golang:alpine AS builder
COPY . /go/src/github.com/sagernet/sing-box
WORKDIR /go/src/github.com/sagernet/sing-box
ENV CGO_ENABLED=0

RUN set -ex \
    && apk add git build-base \
    && export COMMIT=$(git rev-parse --short HEAD) \
    && export VERSION=$(go run ./cmd/internal/read_tag) \
    && export TAGS=$(cat release/DEFAULT_BUILD_TAGS_OTHERS) \
    && export LDFLAGS_SHARED=$(cat release/LDFLAGS) \
    && go build -v -trimpath -tags "${TAGS}" \
        -o /go/bin/sing-box \
        -ldflags "-X \"github.com/sagernet/sing-box/constant.Version=${VERSION}\" ${LDFLAGS_SHARED} -s -w -buildid=" \
        ./cmd/sing-box
FROM --platform=$TARGETPLATFORM alpine AS dist
RUN set -ex \
    && apk update --no-cache \
    && apk upgrade --no-cache \
    && apk add --no-cache bash tzdata ca-certificates nftables curl bird envsubst supervisor jq git
COPY --from=builder /go/bin/sing-box /usr/local/bin/sing-box
COPY entrypoint.sh /entrypoint.sh
WORKDIR /app
ENTRYPOINT /entrypoint.sh