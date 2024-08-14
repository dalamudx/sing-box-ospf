FROM --platform=$BUILDPLATFORM docker.io/alpine:latest
ARG VERSION=""
ARG TARGETPLATFORM
COPY entrypoint.sh /entrypoint.sh
ADD ./sing-box/sing-box /usr/bin/
RUN  apk update && \
     apk add --no-cache curl bird supervisor jq
WORKDIR /app
ENTRYPOINT /entrypoint.sh
