# Home Assistant Add-on: Vikunja

Self-hosted to-do lists & project management with the official Vikunja server.

## Installation

1. Add the repository to your add-on store (see the repository README).
2. Install the **Vikunja** add-on.
3. Start the add-on. The first start builds the image and downloads the official
   Vikunja v2.6.0 release binary — this can take a few minutes.
4. Open the web UI: `http://<your-ha-host>:3456`.
5. Register your account. Once all users are created, consider disabling
   `enable_registration` in the add-on configuration.

## Configuration

Example add-on configuration:

```yaml
enable_registration: true
timezone: Europe/Berlin
```

### Option: `enable_registration`

Allows new users to sign up through the web UI. Enable it for initial setup,
disable it afterwards to keep the instance private.

### Option: `timezone`

Timezone used by Vikunja for due dates and reminders, e.g. `Europe/Berlin`.

## Data & persistence

All state lives in the add-on's persistent data volume:

- SQLite database (`vikunja.db`)
- Uploaded files (`files/`)
- JWT signing secret — generated once, so logins survive add-on restarts

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
