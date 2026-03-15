# lex-slack

Slack integration for [LegionIO](https://github.com/LegionIO/LegionIO). Send chat messages via incoming webhooks and query user information via the Slack API.

## Installation

```bash
gem install lex-slack
```

Or add to your Gemfile:

```ruby
gem 'lex-slack'
```

## Usage

Send a message to a Slack channel using an incoming webhook:

```json
{
  "message": "Hello from Legion!",
  "webhook": "/services/T.../B.../..."
}
```

## Standalone Client

Use `Legion::Extensions::Slack::Client` outside the full LegionIO framework.

```ruby
require 'legion/extensions/slack'
# Webhook mode
client = Legion::Extensions::Slack::Client.new(webhook: 'https://hooks.slack.com/...')
client.send(message: 'Hello from Legion!')

# API mode
client = Legion::Extensions::Slack::Client.new(token: 'xoxb-...')
client.list_users
```

## Runners

### Chat

| Method | Parameters | Description |
|--------|-----------|-------------|
| `send` | `message:`, `webhook:` | Post a message to a Slack incoming webhook |

### User

| Method | Parameters | Description |
|--------|-----------|-------------|
| `list_users` | (none) | List all workspace users |
| `user_info` | `user_id:` | Fetch info for a specific user |
| `set_presence` | `presence:` | Set the bot's presence (`auto` or `away`) |
| `get_presence` | `user_id:` | Get presence status for a user |

## Requirements

- Ruby >= 3.4
- [LegionIO](https://github.com/LegionIO/LegionIO) framework
- Slack incoming webhook URL

## License

MIT
