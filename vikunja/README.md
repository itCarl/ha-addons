# Home Assistant Add-on: Vikunja

![Supports aarch64 Architecture][aarch64-shield]

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

- Official Vikunja **v2.7.0** release binary, verified against a pinned SHA256
  checksum at build time
- Single lightweight container (Alpine base), built locally on your box
- SQLite storage in the add-on's persistent data volume — included in normal
  Home Assistant backups automatically
- Persistent JWT signing secret: logins survive add-on restarts and updates
- Web UI and REST API on port `3456`
- CalDAV endpoint for `todo` entities in Home Assistant

## Configuration

```yaml
enable_registration: true   # allow sign-ups via the web UI; disable after setup
timezone: Europe/Berlin     # timezone for due dates and reminders
```

| Option | Default | Description |
| --- | --- | --- |
| `enable_registration` | `true` | Allow new users to register through the web UI. Anyone who can reach port 3456 can sign up while this is on — meant for initial setup on a trusted network. |
| `timezone` | `Europe/Berlin` | Timezone Vikunja uses for due dates, reminders and recurring tasks. |

## Troubleshooting

- **Add-on not visible in the store** — only `aarch64` is supported right now; the
  store hides it on other architectures. Adding another arch is a two-line change,
  open an issue.
- **Build fails with a checksum error** — the downloaded release did not match the
  pinned SHA256. Retry later; if it persists, treat it as a red flag and open an issue.
- **No HTTPS** — the add-on serves plain HTTP on the LAN. Put it behind a reverse
  proxy (e.g. the Nginx Proxy Manager add-on) for TLS or external access.

See [DOCS.md](DOCS.md) for full installation, persistence and CalDAV details.

[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
