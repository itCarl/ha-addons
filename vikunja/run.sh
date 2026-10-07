#!/bin/sh
set -e

CONFIG=/data/options.json

# opt <jq path> <default>: read an add-on option, falling back to a default
opt() {
  jq -r "($1) // \"$2\" | tostring" "$CONFIG"
}

# optb <jq path> <default>: like opt, but keeps an explicit false
optb() {
  jq -r "if ($1) == null then \"$2\" else ($1) end | tostring" "$CONFIG"
}

REG=$(optb '.enable_registration' true)
TZ=$(opt '.timezone' 'Europe/Berlin')
PUB=$(opt '.public_url' '')
CORS=$(optb '.enable_cors' false)

mkdir -p /data/files

# Persist the signing secret so logins survive add-on restarts
if [ ! -f /data/jwt-secret ]; then
  head -c 32 /dev/urandom | base64 | tr -d '\n=' > /data/jwt-secret
fi

export VIKUNJA_DATABASE_TYPE=sqlite
export VIKUNJA_DATABASE_PATH=/data/vikunja.db
export VIKUNJA_FILES_BASEPATH=/data/files
export VIKUNJA_SERVICE_INTERFACE=:3456
# service.secret replaces the deprecated service.JWTSecret in Vikunja >= 2.6
export VIKUNJA_SERVICE_SECRET="$(cat /data/jwt-secret)"
export VIKUNJA_SERVICE_ENABLEREGISTRATION="$REG"
export VIKUNJA_SERVICE_TIMEZONE="$TZ"
# CORS off by default: the frontend talks to /api/v1 on whatever origin served
# it (direct port or any reverse-proxy domain), so cross-origin requests never
# happen. Vikunja >= 2.6 refuses to start with CORS enabled but no public URL,
# so enable_cors is only honored when public_url is set — note that a fixed
# public URL makes the frontend call that URL from every origin, which breaks
# access through other origins with mixed-content/CORS errors.
if [ "$CORS" = "true" ] && [ -n "$PUB" ]; then
  export VIKUNJA_CORS_ENABLE=true
else
  if [ "$CORS" = "true" ]; then
    echo "[WARN] enable_cors requires public_url to be set - starting with CORS disabled."
  fi
  export VIKUNJA_CORS_ENABLE=false
fi
if [ -n "$PUB" ]; then
  export VIKUNJA_SERVICE_PUBLICURL="$PUB"
fi

export VIKUNJA_LOG_LEVEL="$(opt '.log_level' 'info' | tr '[:lower:]' '[:upper:]')"
export VIKUNJA_FILES_MAXSIZE="$(opt '.files_max_size' '20MB')"

# Mailer (reminders, password reset, account deletion confirmation)
export VIKUNJA_MAILER_ENABLED="$(optb '.mailer.enabled' false)"
if [ "$VIKUNJA_MAILER_ENABLED" = "true" ]; then
  export VIKUNJA_MAILER_HOST="$(opt '.mailer.host' '')"
  export VIKUNJA_MAILER_PORT="$(opt '.mailer.port' 587)"
  export VIKUNJA_MAILER_USERNAME="$(opt '.mailer.username' '')"
  export VIKUNJA_MAILER_PASSWORD="$(opt '.mailer.password' '')"
  export VIKUNJA_MAILER_FROMEMAIL="$(opt '.mailer.from_email' '')"
  export VIKUNJA_MAILER_AUTHTYPE="$(opt '.mailer.auth_type' 'plain')"
  export VIKUNJA_MAILER_FORCESSL="$(optb '.mailer.force_ssl' false)"
  export VIKUNJA_MAILER_SKIPTLSVERIFY="$(optb '.mailer.skip_tls_verify' false)"
  if [ -z "$VIKUNJA_MAILER_HOST" ]; then
    echo "[WARN] mailer.enabled is on but mailer.host is empty - mails will fail."
  fi
fi

# Defaults applied to newly created users
LANG_DEFAULT="$(opt '.user_defaults.language' '')"
if [ -n "$LANG_DEFAULT" ]; then
  export VIKUNJA_DEFAULTSETTINGS_LANGUAGE="$LANG_DEFAULT"
fi
export VIKUNJA_DEFAULTSETTINGS_TIMEZONE="$TZ"
export VIKUNJA_DEFAULTSETTINGS_WEEK_START="$(opt '.user_defaults.week_start' 1)"
export VIKUNJA_DEFAULTSETTINGS_EMAIL_REMINDERS_ENABLED="$(optb '.user_defaults.email_reminders' true)"
export VIKUNJA_DEFAULTSETTINGS_OVERDUE_TASKS_REMINDERS_ENABLED="$(optb '.user_defaults.overdue_reminders' true)"
export VIKUNJA_DEFAULTSETTINGS_OVERDUE_TASKS_REMINDERS_TIME="$(opt '.user_defaults.overdue_reminders_time' '9:00')"
export VIKUNJA_DEFAULTSETTINGS_DISCOVERABLE_BY_NAME="$(optb '.user_defaults.discoverable_by_name' false)"
export VIKUNJA_DEFAULTSETTINGS_DISCOVERABLE_BY_EMAIL="$(optb '.user_defaults.discoverable_by_email' false)"

# Feature switches
export VIKUNJA_SERVICE_ENABLECALDAV="$(optb '.features.caldav' true)"
export VIKUNJA_SERVICE_ENABLELINKSHARING="$(optb '.features.link_sharing' true)"
export VIKUNJA_SERVICE_ENABLETASKATTACHMENTS="$(optb '.features.task_attachments' true)"
export VIKUNJA_SERVICE_ENABLETASKCOMMENTS="$(optb '.features.task_comments' true)"
export VIKUNJA_SERVICE_ENABLEUSERDELETION="$(optb '.features.user_deletion' true)"
export VIKUNJA_SERVICE_ENABLETOTP="$(optb '.features.totp' true)"
export VIKUNJA_WEBHOOKS_ENABLED="$(optb '.features.webhooks' true)"
# Webhooks to Home Assistant (a LAN address) are blocked unless this is on
export VIKUNJA_OUTGOINGREQUESTS_ALLOWNONROUTABLEIPS="$(optb '.features.allow_lan_requests' true)"

# Client IP detection behind a reverse proxy
export VIKUNJA_SERVICE_IPEXTRACTIONMETHOD="$(opt '.reverse_proxy.ip_extraction' 'direct')"
TRUSTED="$(opt '.reverse_proxy.trusted_proxies' '')"
if [ -n "$TRUSTED" ]; then
  export VIKUNJA_SERVICE_TRUSTEDPROXIES="$TRUSTED"
fi

export VIKUNJA_RATELIMIT_ENABLED="$(optb '.ratelimit.enabled' false)"
export VIKUNJA_RATELIMIT_KIND="$(opt '.ratelimit.kind' 'user')"
export VIKUNJA_RATELIMIT_PERIOD="$(opt '.ratelimit.period' 60)"
export VIKUNJA_RATELIMIT_LIMIT="$(opt '.ratelimit.limit' 100)"

# Prometheus /metrics endpoint
export VIKUNJA_METRICS_ENABLED="$(optb '.metrics.enabled' false)"
if [ "$VIKUNJA_METRICS_ENABLED" = "true" ]; then
  export VIKUNJA_METRICS_USERNAME="$(opt '.metrics.username' '')"
  export VIKUNJA_METRICS_PASSWORD="$(opt '.metrics.password' '')"
fi

BIN=/app/vikunja/vikunja

# Maintenance commands arrive on stdin via the Home Assistant service
# hassio.addon_stdin. Only the user-management commands below are accepted.
run_command() {
  CMD=$(echo "$1" | tr -d '"' | sed 's/^ *//;s/ *$//')
  [ -z "$CMD" ] && return 0
  case "$CMD" in
    "user list")
      ;;
    *)
      if ! echo "$CMD" | grep -Eq '^user (delete [0-9]+|change-status [0-9]+( --(enable|disable))?|reset-password [0-9]+|set-admin [A-Za-z0-9_.-]+ --(admin|no-admin))$'; then
        echo "[stdin] rejected command: $CMD"
        return 0
      fi
      ;;
  esac
  case "$CMD" in
    "user delete "*) CMD="$CMD --now --confirm" ;;
  esac
  echo "[stdin] running: vikunja $CMD"
  # shellcheck disable=SC2086
  $BIN $CMD < /dev/null || echo "[stdin] command failed: $CMD"
}

set +e

$BIN &
PID=$!

# The stdin reader runs in the background so a blocking read never delays
# shutdown: `wait` below is interruptible by the TERM trap, `read` is not.
# Background jobs get /dev/null as stdin unless it is redirected explicitly,
# hence the duplicate on fd 3.
exec 3<&0
(
  while read -r LINE; do
    run_command "$LINE"
  done
) <&3 &
READER=$!

trap 'kill -TERM "$PID" 2>/dev/null' TERM INT

wait "$PID"
STATUS=$?
# A trapped signal interrupts the first wait; wait again for a clean exit
if kill -0 "$PID" 2>/dev/null; then
  wait "$PID"
  STATUS=$?
fi
kill "$READER" 2>/dev/null
exit "$STATUS"
