FROM --platform=$BUILDPLATFORM golang:alpine AS builder
COPY . /go/src/github.com/sagernet/sing-box
WORKDIR /go/src/github.com/sagernet/sing-box
ARG TARGETOS TARGETARCH OPTIONS
ARG GOPROXY=""
ENV GOPROXY ${GOPROXY}
ENV CGO_ENABLED=0
ENV GOOS=$TARGETOS
ENV GOARCH=$TARGETARCH
ENV OPTIONS=$OPTIONS
RUN set -ex \
    && apk upgrade --no-cache \
    && apk add --no-cache git build-base \
    && export COMMIT=$(git rev-parse --short HEAD) \
    && export VERSION=$(go run ./cmd/internal/read_tag) \
    && go build -v -trimpath -tags \
    "${OPTIONS}" \
        -o /go/bin/sing-box \
        -ldflags "-X \"github.com/sagernet/sing-box/constant.Version=$VERSION\" -s -w -buildid=" \
        ./cmd/sing-box
FROM --platform=$TARGETPLATFORM alpine AS dist
RUN set -ex \
    && apk upgrade --no-cache \
    && apk add --no-cache bash tzdata ca-certificates nftables curl bird supervisor jq git
COPY --from=builder /go/bin/sing-box /usr/local/bin/sing-box
COPY entrypoint.sh /entrypoint.sh
WORKDIR /app
ENTRYPOINT /entrypoint.sh