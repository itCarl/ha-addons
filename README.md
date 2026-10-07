# itCarl's Home Assistant Add-ons

![Home Assistant add-on][ha-shield]
![Vikunja add-on version][vikunja-version-shield]
![Vikunja][vikunja-shield]
[![License][license-shield]](LICENSE)
![Maintenance][maintenance-shield]
![Last commit][commit-shield]
[![Issues][issues-shield]](https://github.com/itCarl/ha-addons/issues)
![Supports aarch64 Architecture][aarch64-shield]
![Supports amd64 Architecture][amd64-shield]
[![Stars][stars-shield]](https://github.com/itCarl/ha-addons/stargazers)

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

![Vikunja add-on version][vikunja-version-shield]

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
licenses (Vikunja: AGPL-3.0 by the Vikunja authors). The Vikunja logo used as the
add-on icon is not covered by the MIT License — see [NOTICE](NOTICE).

These are unofficial add-ons, not affiliated with or endorsed by the projects they wrap.

[license-shield]: https://img.shields.io/github/license/itCarl/ha-addons.svg
[maintenance-shield]: https://img.shields.io/maintenance/yes/2026.svg
[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
[vikunja-version-shield]: https://img.shields.io/badge/dynamic/yaml?label=version&query=%24.version&url=https%3A%2F%2Fraw.githubusercontent.com%2FitCarl%2Fha-addons%2Fmain%2Fvikunja%2Fconfig.yaml
[ha-shield]: https://img.shields.io/badge/Home%20Assistant-add--on-41BDF5?logo=homeassistant&logoColor=white
[vikunja-shield]: https://img.shields.io/badge/Vikunja-v2.7.0-196aff
[commit-shield]: https://img.shields.io/github/last-commit/itCarl/ha-addons
[issues-shield]: https://img.shields.io/github/issues/itCarl/ha-addons
[stars-shield]: https://img.shields.io/github/stars/itCarl/ha-addons?style=social
