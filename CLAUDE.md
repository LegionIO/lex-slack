# lex-slack: Slack Integration for LegionIO

**Repository Level 3 Documentation**
- **Parent**: `/Users/miverso2/rubymine/legion/extensions-other/CLAUDE.md`
- **Grandparent**: `/Users/miverso2/rubymine/legion/CLAUDE.md`

## Purpose

Legion Extension that connects LegionIO to Slack. Provides runners for sending chat messages via incoming webhooks and querying user information via the Slack API.

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
| `lib/legion/extensions/slack/runners/user.rb` | User queries |
| `lib/legion/extensions/slack/helpers/client.rb` | Faraday client (hooks.slack.com, JSON content-type) |

## Runner: Chat

```ruby
# Payload
{ message: "Hello from Legion!", webhook: "/services/T.../B.../..." }
```

The `send` method posts `{ text: message }` as JSON to the Slack incoming webhook URL.

## Dependencies

| Gem | Purpose |
|-----|---------|
| `faraday` (>= 2.0) | HTTP client |
| `multi_json` | JSON parser abstraction |

## Development

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

---

**Maintained By**: Matthew Iverson (@Esity)
