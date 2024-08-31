FROM --platform=$BUILDPLATFORM docker.io/alpine:latest
COPY entrypoint.sh /entrypoint.sh
ADD ./sing-box/sing-box /usr/bin/
RUN  apk update && apk upgrade && \
     apk add --no-cache curl bird supervisor jq
WORKDIR /app
ENTRYPOINT /entrypoint.sh
