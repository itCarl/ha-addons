#!/bin/sh
set -e

CONFIG=/data/options.json
REG=$(jq -r '.enable_registration // true' "$CONFIG")
TZ=$(jq -r '.timezone // "Europe/Berlin"' "$CONFIG")

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
# No VIKUNJA_SERVICE_PUBLICURL: the frontend then talks to /api/v1 on whatever
# origin served it (direct port or any reverse-proxy domain) — a fixed URL breaks
# the other origins with mixed-content/CORS errors.

exec /app/vikunja/vikunja
