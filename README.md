# itCarl's Home Assistant Add-ons

[![License][license-shield]](LICENSE)
![Maintenance][maintenance-shield]
![Supports aarch64 Architecture][aarch64-shield]

A collection of add-ons for Home Assistant OS — self-hosted apps wrapped to run
supervised on your Home Assistant box: managed, backed up and updated like any
other add-on, no separate server required.

## Installation

[![Open your Home Assistant instance and show the add add-on repository dialog with a specific repository URL pre-filled.](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2FitCarl%2Fha-addons)

Or manually: **Settings → Add-ons → Add-on Store → ⋮ → Repositories** and add
`https://github.com/itCarl/ha-addons`, then install the add-on of your choice
from the store.

## Add-ons

### ✅ [Vikunja](vikunja/)

_Self-hosted to-do lists & project management._

The open-source alternative to Todoist/Trello: projects, labels, due dates with
reminders, Kanban/Gantt/table views, shared lists, mobile apps and a REST API.
Runs the official Vikunja server binary (SHA256-pinned) with persistent SQLite
storage; connects to Home Assistant `todo` entities via CalDAV. Mailer, user defaults,
feature switches, proxy, rate limit and metrics are add-on options in the HA UI.

[Documentation](vikunja/DOCS.md)

## Contributing

Issues and pull requests are welcome — especially additional architectures and
new add-on wrappers.

## License

MIT License — see [LICENSE](LICENSE). The wrapped applications keep their own
licenses (Vikunja: AGPL-3.0 by the Vikunja authors).

[license-shield]: https://img.shields.io/github/license/itCarl/ha-addons.svg
[maintenance-shield]: https://img.shields.io/maintenance/yes/2026.svg
[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
