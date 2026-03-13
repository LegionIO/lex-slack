# lex-slack: Slack Integration for LegionIO

**Repository Level 3 Documentation**
- **Category**: `/Users/miverso2/rubymine/legion/extensions/CLAUDE.md`

## Purpose

Legion Extension that connects LegionIO to Slack. Provides runners for sending chat messages and querying user information via the Slack API.

**License**: MIT

## Architecture

```
Legion::Extensions::Slack
├── Runners/
│   ├── Chat               # Send messages to Slack channels
│   └── User               # Query Slack user information
└── Helpers/
    └── Client             # Slack API client (Faraday-based)
```

## Dependencies

| Gem | Purpose |
|-----|---------|
| `faraday` | HTTP client |
| `faraday_middleware` | HTTP middleware |
| `multi_json` | JSON parser abstraction |

## Testing

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

---

**Maintained By**: Matthew Iverson (@Esity)
