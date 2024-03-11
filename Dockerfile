FROM --platform=$BUILDPLATFORM docker.io/alpine:latest
ARG VERSION=""
ARG TARGETPLATFORM
COPY entrypoint.sh /entrypoint.sh
RUN  apk update && \
     apk add --no-cache curl bird supervisor jq && \
     FILENAME=sing-box-$(echo $VERSION|sed 's/v//g')-$(echo $TARGETPLATFORM|sed 's/\//-/g') && \
     curl -Ls https://github.com/SagerNet/sing-box/releases/download/$VERSION/$FILENAME.tar.gz |tar -xz $FILENAME/sing-box -C /usr/bin/ --strip-components 1
WORKDIR /app
ENTRYPOINT /entrypoint.sh
