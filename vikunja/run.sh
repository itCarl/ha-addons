#!/bin/sh
set -e

CONFIG=/data/options.json
REG=$(jq -r '.enable_registration // true' "$CONFIG")
TZ=$(jq -r '.timezone // "Europe/Berlin"' "$CONFIG")
PUB=$(jq -r '.public_url // ""' "$CONFIG")

mkdir -p /data/files

# Persist the JWT secret so logins survive add-on restarts
if [ ! -f /data/jwt-secret ]; then
  head -c 32 /dev/urandom | base64 | tr -d '\n=' > /data/jwt-secret
fi

export VIKUNJA_DATABASE_TYPE=sqlite
export VIKUNJA_DATABASE_PATH=/data/vikunja.db
export VIKUNJA_FILES_BASEPATH=/data/files
export VIKUNJA_SERVICE_INTERFACE=:3456
export VIKUNJA_SERVICE_JWTSECRET="$(cat /data/jwt-secret)"
export VIKUNJA_SERVICE_ENABLEREGISTRATION="$REG"
export VIKUNJA_SERVICE_TIMEZONE="$TZ"
# CORS off: the frontend talks to /api/v1 on whatever origin served it (direct
# port or any reverse-proxy domain), so cross-origin requests never happen. With
# CORS enabled Vikunja refuses to start unless a fixed public URL is set, and a
# fixed URL breaks all other origins with mixed-content/CORS errors.
export VIKUNJA_CORS_ENABLE=false
if [ -n "$PUB" ]; then
  export VIKUNJA_SERVICE_PUBLICURL="$PUB"
fi

exec /app/vikunja/vikunja
