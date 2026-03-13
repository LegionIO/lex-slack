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

## Runners

| Runner | Methods |
|--------|---------|
| Chat | `send(message:, webhook:)` - post to Slack incoming webhook |
| User | User information queries |

## Requirements

- Ruby >= 3.4
- [LegionIO](https://github.com/LegionIO/LegionIO) framework
- Slack incoming webhook URL

## License

MIT
