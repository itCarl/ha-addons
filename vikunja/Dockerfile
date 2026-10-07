FROM alpine:3.20

RUN apk add --no-cache curl unzip ca-certificates tzdata jq

# Set by the Home Assistant Supervisor when it builds the add-on (aarch64 or amd64)
ARG BUILD_ARCH=aarch64
ARG VIKUNJA_VERSION=2.7.0
ARG VIKUNJA_SHA256_AARCH64=4e99c592197888382f86ce3d74684ab56dcca1f36a7cf45a557ba9b8297e3217
ARG VIKUNJA_SHA256_AMD64=569861fd690f9ffc812e39e20be3943b882d4549a19e556e47066e71e29ca1b9

RUN case "${BUILD_ARCH}" in \
      aarch64) ARCH=arm64; SHA256="${VIKUNJA_SHA256_AARCH64}" ;; \
      amd64)   ARCH=amd64; SHA256="${VIKUNJA_SHA256_AMD64}" ;; \
      *) echo "Unsupported architecture: ${BUILD_ARCH}" >&2; exit 1 ;; \
    esac \
 && mkdir -p /app/vikunja \
 && curl -fsSL -o /tmp/vikunja.zip \
      "https://dl.vikunja.io/vikunja/v${VIKUNJA_VERSION}/vikunja-v${VIKUNJA_VERSION}-linux-${ARCH}-full.zip" \
 && echo "${SHA256}  /tmp/vikunja.zip" | sha256sum -c - \
 && unzip /tmp/vikunja.zip -d /app/vikunja/ \
 && rm /tmp/vikunja.zip \
 && cd /app/vikunja \
 && BIN=$(ls vikunja-* | grep -Ev '\.(sig|sha256)$' | head -1) \
 && mv "$BIN" vikunja \
 && chmod +x vikunja

COPY run.sh /run.sh
RUN chmod +x /run.sh

WORKDIR /app/vikunja
CMD ["/run.sh"]
