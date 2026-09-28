FROM alpine:3.20

RUN apk add --no-cache curl unzip ca-certificates tzdata jq

ARG VIKUNJA_SHA256=b30e0ef2ba86ed1138a53097dc386eb0ac42483f85526325687f909c3430477b

RUN mkdir -p /app/vikunja \
 && curl -fsSL -o /tmp/vikunja.zip \
      https://dl.vikunja.io/vikunja/v2.6.0/vikunja-v2.6.0-linux-arm64-full.zip \
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
