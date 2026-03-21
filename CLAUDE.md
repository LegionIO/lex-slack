# lex-slack: Slack Integration for LegionIO

**Repository Level 3 Documentation**
- **Parent**: `/Users/miverso2/rubymine/legion/extensions-other/CLAUDE.md`
- **Grandparent**: `/Users/miverso2/rubymine/legion/CLAUDE.md`

## Purpose

Comprehensive Legion Extension connecting LegionIO to Slack. Covers the Slack Web API (messaging, conversations, users, reactions, files, pins, bookmarks, reminders, usergroups, views, search), incoming webhooks, Block Kit builder, and a configurable message polling actor.

**Version**: 0.3.0
**GitHub**: https://github.com/LegionIO/lex-slack
**License**: MIT

## Architecture

```
Legion::Extensions::Slack
+-- Helpers/
|   +-- Client             # Named builders: api_connection (Web API), webhook_connection
+-- Runners/
|   +-- Blocks             # Pure Block Kit builder (no HTTP)
|   +-- Chat               # post_message, send_webhook, update, delete, schedule (6 methods)
|   +-- Conversations      # list, info, history, replies, members, join, leave, invite, open, create, archive, topic (12 methods)
|   +-- Users              # list, info, lookup_by_email, presence (5 methods)
|   +-- Reactions          # add, remove, get, list (4 methods)
|   +-- Files              # upload (two-step), list, info, delete, share (5 methods)
|   +-- Pins               # add, remove, list (3 methods)
|   +-- Bookmarks          # add, edit, remove, list (4 methods)
|   +-- Reminders          # add, complete, delete, info, list (5 methods)
|   +-- Usergroups         # CRUD + users.list/update (7 methods)
|   +-- Views              # open, push, update, publish (4 methods)
|   +-- Search             # search_messages, search_files (2 methods)
+-- Actors/
|   +-- MessagePoller      # Poll conversations.history (disabled by default)
+-- Client                 # Standalone client including all runners
```

## Connection Builders

Two named Faraday connection builders in `Helpers::Client`:
- `api_connection(token:, base_url:, **)` — targets `https://slack.com/api/`, Bearer token auth
- `webhook_connection(base_url:, **)` — targets `https://hooks.slack.com`, no auth

All runners use `api_connection` except `Chat#send_webhook` which uses `webhook_connection`.

## Standalone Client

`Client.new(token:, webhook:, **)` stores credentials in `@opts` and injects them into every connection call via `super(**@opts, **override)`. All 12 runner modules are included. Per-call token override supported.

## Actor: MessagePoller

Configurable polling actor, disabled by default. Settings:

```json
{
  "lex-slack": {
    "token": "xoxb-...",
    "poller": {
      "enabled": false,
      "interval": 30,
      "channels": [],
      "limit": 50
    }
  }
}
```

Uses in-memory high-water mark per channel. Publishes to Legion transport if available.

## Dependencies

| Gem | Purpose |
|-----|---------|
| `faraday` (>= 2.0) | HTTP client |

## Development

141 specs across 16 spec files.

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

---

**Maintained By**: Matthew Iverson (@Esity)
