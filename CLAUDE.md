# lex-slack: Slack Integration for LegionIO

**Repository Level 3 Documentation**
- **Parent**: `/Users/miverso2/rubymine/legion/extensions-other/CLAUDE.md`
- **Grandparent**: `/Users/miverso2/rubymine/legion/CLAUDE.md`

## Purpose

Legion Extension that connects LegionIO to Slack. Provides runners for sending chat messages via incoming webhooks and querying user information via the Slack API.

**Version**: 0.2.0
**GitHub**: https://github.com/LegionIO/lex-slack
**License**: MIT

## Architecture

```
Legion::Extensions::Slack
├── Runners/
│   ├── Chat               # Send messages to Slack via incoming webhook
│   └── User               # Query Slack user information
└── Helpers/
    └── Client             # Faraday client pointing to https://hooks.slack.com
```

## Key Files

| Path | Purpose |
|------|---------|
| `lib/legion/extensions/slack.rb` | Entry point, extension registration |
| `lib/legion/extensions/slack/runners/chat.rb` | `send(message:, webhook:)` - posts JSON to webhook URL |
| `lib/legion/extensions/slack/runners/user.rb` | `list_users`, `user_info`, `set_presence`, `get_presence` via Slack Web API |
| `lib/legion/extensions/slack/helpers/client.rb` | Faraday client (hooks.slack.com, JSON content-type) |
| `lib/legion/extensions/slack/client.rb` | Standalone `Client` class accepting `webhook:` and `token:` opts |

## Runner: Chat

```ruby
# Payload
{ message: "Hello from Legion!", webhook: "/services/T.../B.../..." }
```

The `send` method posts `{ text: message }` as JSON to the Slack incoming webhook URL.

## Runner: User

Methods use the Slack Web API (Bearer token auth):
- `list_users` — list all workspace users
- `user_info(user_id:)` — fetch info for a specific user
- `set_presence(presence:)` — set the bot's presence (`auto` or `away`)
- `get_presence(user_id:)` — get presence status for a user

## Standalone Client

`Client` accepts `webhook:` and `token:` keyword options and includes both `Chat` and `User` runners, enabling use outside the Legion framework.

## Dependencies

| Gem | Purpose |
|-----|---------|
| `faraday` (>= 2.0) | HTTP client |
| `multi_json` | JSON parser abstraction |

## Development

21 specs total across `spec/legion/extensions/slack/client_spec.rb`, `runners/chat_spec.rb`, and `runners/user_spec.rb`.

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

---

**Maintained By**: Matthew Iverson (@Esity)
