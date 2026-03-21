# Changelog

## [0.3.0] - 2026-03-20

### Added
- Named connection builders: `api_connection` (Slack Web API) and `webhook_connection` (incoming webhooks)
- Runners::Blocks - Block Kit builder (section, divider, header, actions, context, image, input, button, select, datepicker, etc.)
- Runners::Chat - post_message, send_webhook, update_message, delete_message, schedule_message, delete_scheduled
- Runners::Conversations - list, info, history, replies, members, join, leave, invite, open, create, archive, set_topic
- Runners::Users - list, info, lookup_by_email, get_presence, set_presence
- Runners::Reactions - add, remove, get, list
- Runners::Files - upload (two-step external), list, info, delete, share
- Runners::Pins - add, remove, list
- Runners::Bookmarks - add, edit, remove, list
- Runners::Reminders - add, complete, delete, info, list
- Runners::Usergroups - create, update, disable, enable, list, list_users, update_users
- Runners::Views - open, push, update, publish
- Runners::Search - search_messages, search_files
- Actor::MessagePoller - configurable channel polling with high-water mark tracking (disabled by default)
- Standalone Client including all runners with automatic credential injection

### Changed
- Complete rebuild from v0.2.0
- Dropped `multi_json` dependency (unused)
- Renamed `Runners::User` to `Runners::Users` (plural, matches API resource)
- Replaced single `client` helper with named `api_connection`/`webhook_connection` builders

### Removed
- Old `Helpers::Client#client` method (replaced by named builders)

## [0.2.0] - 2026-03-15

### Added
- `Runners::User` with `list_users`, `user_info`, `set_presence`, and `get_presence` methods using Slack Web API Bearer token auth
- Standalone `Client` class that includes `Helpers::Client`, `Runners::Chat`, and `Runners::User` for use outside the Legion runtime
- Specs for `Client`, `Runners::Chat` (expanded), and `Runners::User`

## [0.1.0] - 2026-03-13

### Added
- Initial release
