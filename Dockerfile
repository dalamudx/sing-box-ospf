FROM --platform=$BUILDPLATFORM golang:alpine AS builder
COPY . /go/src/github.com/sagernet/sing-box
WORKDIR /go/src/github.com/sagernet/sing-box
ARG OPTIONS

ENV CGO_ENABLED=0
ENV OPTIONS=$OPTIONS
RUN set -ex \
    && apk update \
    && apk upgrade --no-cache \
    && apk add --no-cache git build-base \
    && export COMMIT=$(git rev-parse --short HEAD) \
    && export VERSION=$(go run ./cmd/internal/read_tag) \
    && go build -v -trimpath -tags \
    "${OPTIONS}" \
        -o /go/bin/sing-box \
        -ldflags "-X \"github.com/sagernet/sing-box/constant.Version=$VERSION\" -s -w -buildid= -checklinkname=0" \
        ./cmd/sing-box
FROM --platform=$TARGETPLATFORM alpine AS dist
ENV BIRD_INTERFACE=${BIRD_INTERFACE}
ENV BIRD_ROUTER_ID=${BIRD_ROUTER_ID}
ENV GH_PROXY=${GH_PROXY}
ENV GEO_PROXY=${GEO_PROXY}
RUN set -ex \
    && apk update \
    && apk upgrade \
    && apk add bash tzdata ca-certificates nftables curl bird envsubst supervisor jq git
COPY --from=builder /go/bin/sing-box /usr/local/bin/sing-box
COPY entrypoint.sh /entrypoint.sh
WORKDIR /app
ENTRYPOINT /entrypoint.sh