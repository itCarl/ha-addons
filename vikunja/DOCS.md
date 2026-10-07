# Home Assistant Add-on: Vikunja

Self-hosted to-do lists & project management with the official Vikunja server.

## Installation

1. Add the repository to your add-on store (see the repository README).
2. Install the **Vikunja** add-on.
3. Start the add-on. The first start builds the image and downloads the official
   Vikunja v2.7.0 release binary — this can take a few minutes.
4. Open the web UI: `http://<your-ha-host>:3456`.
5. Register your account. Once all users are created, consider disabling
   `enable_registration` in the add-on configuration.

## Configuration

Example add-on configuration (only the most common options shown):

```yaml
enable_registration: false
timezone: Europe/Berlin
mailer:
  enabled: true
  host: smtp.example.com
  port: 587
  username: todo@example.com
  password: "..."
  from_email: "Vikunja <todo@example.com>"
user_defaults:
  language: de-DE
  week_start: 1
features:
  allow_lan_requests: true
```

### Option: `enable_registration`

Allows new users to sign up through the web UI. Enable it for initial setup,
disable it afterwards to keep the instance private.

### Option: `timezone`

Timezone used by Vikunja for due dates and reminders, e.g. `Europe/Berlin`. It is
also the default timezone of new users.

### Options: `enable_cors` / `public_url`

Leave both empty/off when the UI is only used on one origin. `public_url` is used
in e-mail links; when set, the frontend always calls that URL, so other hostnames
stop working. CORS can only be enabled together with `public_url`.

### Options: `log_level`, `files_max_size`

Log verbosity and the maximum upload size (e.g. `20MB`).

### Option group: `mailer`

SMTP settings. Without a mailer Vikunja sends no mails at all: no reminders, no
password reset, no account deletion confirmation. Port 465 needs `force_ssl: true`.

### Option group: `user_defaults`

Defaults for **newly created** users: UI language (e.g. `de-DE`), week start
(`1` = Monday), e-mail reminders, the daily overdue digest and its time, and
whether others can find the user by name or e-mail when sharing. Existing users
keep their own settings.

### Option group: `features`

Switches for CalDAV, link sharing, attachments, comments, account deletion,
TOTP and webhooks. `allow_lan_requests` lets webhooks reach private addresses -
needed for webhooks to Home Assistant itself; Vikunja blocks them otherwise.

### Option group: `reverse_proxy`

Behind a reverse proxy, set `ip_extraction` to `xff` and list the proxy networks
in `trusted_proxies` (comma-separated CIDRs) so logs and rate limits see the real
client IP.

### Option group: `ratelimit`

Optional API rate limit per `user` or `ip`: `limit` requests per `period` seconds.

### Option group: `metrics`

Exposes Prometheus metrics at `/api/v1/metrics`, protected by the given
basic-auth user and password.

## Maintenance commands (user management)

Vikunja's admin panel is a paid feature, but the add-on accepts a small set of
CLI commands on stdin. Send them with the Home Assistant service
`hassio.addon_stdin`:

```yaml
action: hassio.addon_stdin
data:
  addon: <slug>_vikunja
  input: user list
```

Accepted commands (everything else is rejected and logged):

| Input | Effect |
| --- | --- |
| `user list` | list all users with their ids |
| `user delete <id>` | delete the user **immediately** (no confirmation mail) |
| `user change-status <id> [--enable\|--disable]` | enable/disable a user |
| `user reset-password <id>` | send a password reset mail (needs the mailer) |
| `user set-admin <username-or-id> --admin\|--no-admin` | set the instance-admin flag |

The output appears in the add-on log.

## Data & persistence

All state lives in the add-on's persistent data volume:

- SQLite database (`vikunja.db`)
- Uploaded files (`files/`)
- Signing secret (`service.secret`) — generated once, so logins survive add-on restarts

Uninstalling the add-on removes this data. Back it up via normal Home Assistant
backups (the add-on data volume is included automatically).

## Connecting to Home Assistant

Vikunja exposes a CalDAV endpoint that the Home Assistant core
[CalDAV integration](https://www.home-assistant.io/integrations/caldav/) can
consume, turning your Vikunja projects into `todo` entities:

- URL: `http://<your-ha-host>:3456/dav/`
- Username / password: your Vikunja account

Note: CalDAV support is marked experimental by the Vikunja project. Basic list
and check-off operations work; advanced features may not.

## Support

- Vikunja documentation: https://vikunja.io/docs/
- Issues with this add-on: open an issue on this repository
