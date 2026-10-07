# Changelog

## 2.7.0-3

- Licensing clarified: new `NOTICE` file - the Vikunja logo used as the add-on icon
  belongs to the Vikunja authors (AGPL-3.0) and is not covered by this repository's
  MIT License.
- Both READMEs now state that this is an unofficial add-on, not affiliated with the
  Vikunja project.
- More README badges (Home Assistant add-on, bundled Vikunja version, licenses, activity).
- No functional changes.

## 2.7.0-2

- New architecture: **amd64** (Intel/AMD machines), next to aarch64. The build picks the
  matching signed Vikunja release zip and verifies its pinned SHA256.
- The binary selection now also skips the `.sha256` file shipped inside the release zip.

## 2.7.0-1

- Update Vikunja to [v2.7.0](https://vikunja.io/changelog/vikunja-2.7.0-was-released/):
  six security fixes, an MCP server for AI assistants and a new date picker.
- The release zip (signed by the Vikunja release key) is pinned to its new SHA256.
- No configuration changes: all add-on options work as before.

## 2.6.0-6

- New add-on options, editable in the Home Assistant UI:
  - `mailer`: SMTP server for reminders, password reset and account deletion mails.
  - `user_defaults`: language, week start, e-mail reminders and overdue digest for new users.
  - `features`: switches for CalDAV, link sharing, attachments, comments, account
    deletion, TOTP and webhooks.
  - `features.allow_lan_requests`: lets webhooks reach private addresses such as
    Home Assistant itself.
  - `reverse_proxy`: client IP detection behind a proxy (`ip_extraction`, `trusted_proxies`).
  - `ratelimit`, `metrics` (Prometheus), `log_level`, `files_max_size`.
- User management without a shell: send `user list`, `user delete <id>`,
  `user change-status`, `user reset-password` or `user set-admin` via the
  `hassio.addon_stdin` service. Other input is rejected.
- Uses `service.secret` instead of the deprecated JWT secret setting (same value,
  existing logins stay valid).

## 2.6.0-5

- New option `enable_cors` (only honoured together with `public_url`).
- Option names and descriptions in the configuration UI.

## 2.6.0-4

- CORS disabled by default: Vikunja 2.6 refuses to start with CORS on but no public URL.
- New optional `public_url` option.

## 2.6.0-3

- First release: official Vikunja v2.6.0 arm64 binary (SHA256-pinned), SQLite
  database, files and signing secret in the add-on's persistent storage, web UI
  and API on port 3456.
