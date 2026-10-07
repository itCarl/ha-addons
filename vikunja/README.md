# Home Assistant Add-on: Vikunja

![Home Assistant add-on][ha-shield]
![Version][version-shield]
![Vikunja][vikunja-shield]
![Supports aarch64 Architecture][aarch64-shield]
![Supports amd64 Architecture][amd64-shield]
[![License][license-shield]](../LICENSE)
![Upstream license][upstream-license-shield]
![Last commit][commit-shield]

Self-hosted to-do lists & project management.

## About

[Vikunja](https://vikunja.io) is an open-source, self-hosted to-do and project
management app — often described as a self-hosted alternative to Todoist or Trello.
It offers projects, sub-projects, labels, priorities, due dates with reminders,
recurring tasks, file attachments and multiple views (list, Gantt, table, Kanban).
Lists can be shared between users; mobile apps and a REST API are available.

This add-on wraps the **official Vikunja server binary** (unified build: API + web
frontend in one process) so it runs supervised on Home Assistant OS.

## Features

- Official Vikunja **v2.7.0** release binary for `aarch64` and `amd64`, verified
  against a pinned SHA256 checksum at build time
- Single lightweight container (Alpine base), built locally on your box
- SQLite storage in the add-on's persistent data volume — included in normal
  Home Assistant backups automatically
- Persistent signing secret: logins survive add-on restarts and updates
- Web UI and REST API on port `3456`
- CalDAV endpoint for `todo` entities in Home Assistant
- Vikunja's configuration as add-on options in the Home Assistant UI: mailer (SMTP),
  defaults for new users, feature switches, reverse proxy, rate limit, Prometheus metrics
- User management without a shell: `vikunja user ...` commands via the
  `hassio.addon_stdin` service (list, delete, enable/disable, password reset, admin flag)

## Configuration

```yaml
enable_registration: false  # allow sign-ups via the web UI; disable after setup
timezone: Europe/Berlin     # timezone for due dates and reminders
mailer:
  enabled: true             # SMTP for reminders, password reset, deletion mails
  host: smtp.example.com
```

| Option | Default | Description |
| --- | --- | --- |
| `enable_registration` | `true` | Allow new users to register through the web UI. Anyone who can reach port 3456 can sign up while this is on — meant for initial setup on a trusted network. |
| `timezone` | `Europe/Berlin` | Timezone for due dates, reminders and recurring tasks; also the default for new users. |
| `enable_cors` / `public_url` | `false` / empty | CORS (only together with a public URL) and the URL used in e-mail links. |
| `log_level` / `files_max_size` | `info` / `20MB` | Log verbosity and maximum upload size. |
| `mailer` | disabled | SMTP server; without it Vikunja sends no mails at all. |
| `user_defaults` | `de-DE`, Monday | Language, week start, reminders and overdue digest for new users. |
| `features` | all on | CalDAV, link sharing, attachments, comments, account deletion, TOTP, webhooks, LAN requests for webhooks. |
| `reverse_proxy` | `direct` | Client IP detection behind a proxy. |
| `ratelimit` / `metrics` | off | API rate limit and Prometheus endpoint. |

Every option is explained in [DOCS.md](DOCS.md); release notes are in [CHANGELOG.md](CHANGELOG.md).

## Troubleshooting

- **Add-on not visible in the store** — only `aarch64` and `amd64` are supported; the
  store hides it on other architectures (e.g. 32-bit ARM). Open an issue if you need one.
- **Build fails with a checksum error** — the downloaded release did not match the
  pinned SHA256. Retry later; if it persists, treat it as a red flag and open an issue.
- **No HTTPS** — the add-on serves plain HTTP on the LAN. Put it behind a reverse
  proxy (e.g. the Nginx Proxy Manager add-on) for TLS or external access.

See [DOCS.md](DOCS.md) for full installation, options, maintenance commands, persistence and CalDAV details.

[version-shield]: https://img.shields.io/badge/dynamic/yaml?label=version&query=%24.version&url=https%3A%2F%2Fraw.githubusercontent.com%2FitCarl%2Fha-addons%2Fmain%2Fvikunja%2Fconfig.yaml
[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
[license-shield]: https://img.shields.io/github/license/itCarl/ha-addons.svg
[upstream-license-shield]: https://img.shields.io/badge/Vikunja%20license-AGPL--3.0-blue
[ha-shield]: https://img.shields.io/badge/Home%20Assistant-add--on-41BDF5?logo=homeassistant&logoColor=white
[vikunja-shield]: https://img.shields.io/badge/Vikunja-v2.7.0-196aff
[commit-shield]: https://img.shields.io/github/last-commit/itCarl/ha-addons
