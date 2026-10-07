FROM alpine:3.20

RUN apk add --no-cache curl unzip ca-certificates tzdata jq

ARG VIKUNJA_SHA256=4e99c592197888382f86ce3d74684ab56dcca1f36a7cf45a557ba9b8297e3217

RUN mkdir -p /app/vikunja \
 && curl -fsSL -o /tmp/vikunja.zip \
      https://dl.vikunja.io/vikunja/v2.7.0/vikunja-v2.7.0-linux-arm64-full.zip \
 && echo "${VIKUNJA_SHA256}  /tmp/vikunja.zip" | sha256sum -c - \
 && unzip /tmp/vikunja.zip -d /app/vikunja/ \
 && rm /tmp/vikunja.zip \
 && cd /app/vikunja \
 && BIN=$(ls vikunja-* | grep -v '\.sig$' | head -1) \
 && mv "$BIN" vikunja \
 && chmod +x vikunja

COPY run.sh /run.sh
RUN chmod +x /run.sh

WORKDIR /app/vikunja
CMD ["/run.sh"]
