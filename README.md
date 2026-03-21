# lex-slack

Comprehensive Slack integration for [LegionIO](https://github.com/LegionIO/LegionIO). Covers the Slack Web API (messaging, conversations, users, reactions, files, pins, bookmarks, reminders, usergroups, views, search), incoming webhooks, Block Kit builder, and a configurable message polling actor.

## Installation

```bash
gem install lex-slack
```

Or add to your Gemfile:

```ruby
gem 'lex-slack'
```

## Standalone Client

Use `Legion::Extensions::Slack::Client` outside the full LegionIO framework. The client stores credentials and injects them into every API call automatically.

```ruby
require 'legion/extensions/slack'

client = Legion::Extensions::Slack::Client.new(token: 'xoxb-...')

# Messaging
client.post_message(channel: '#general', text: 'Hello from Legion!')
client.post_message(channel: '#alerts', text: 'fallback', blocks: [
  client.header(text: 'Incident Alert'),
  client.section(text: client.mrkdwn('*web-prod-03* is unreachable')),
  client.divider,
  client.actions(elements: [
    client.button(text: 'Acknowledge', action_id: 'ack', style: 'primary'),
    client.button(text: 'Escalate', action_id: 'esc', style: 'danger')
  ])
])

# Conversations
channels = client.list_conversations
history = client.conversation_history(channel: 'C123ABC')

# Users
users = client.list_users
user = client.lookup_by_email(email: 'jane.doe@example.com')

# Reactions
client.add_reaction(channel: 'C123', timestamp: '1234.5678', name: 'thumbsup')

# Files (two-step upload)
client.upload_file(filename: 'report.csv', content: csv_data, channel: '#reports')

# Webhooks (no token needed)
webhook_client = Legion::Extensions::Slack::Client.new(webhook: '/services/T.../B.../...')
webhook_client.send_webhook(message: 'Quick alert!')
```

## Runners

### Chat

| Method | Key Parameters | Description |
|--------|---------------|-------------|
| `post_message` | `channel:, text:, blocks:, thread_ts:` | Post a message (supports Block Kit) |
| `send_webhook` | `message:, webhook:` | Post via incoming webhook |
| `update_message` | `channel:, ts:, text:, blocks:` | Update an existing message |
| `delete_message` | `channel:, ts:` | Delete a message |
| `schedule_message` | `channel:, text:, post_at:` | Schedule a future message |
| `delete_scheduled` | `channel:, scheduled_message_id:` | Cancel a scheduled message |

### Conversations

| Method | Key Parameters | Description |
|--------|---------------|-------------|
| `list_conversations` | `types:, cursor:, limit:` | List channels |
| `conversation_info` | `channel:` | Get channel details |
| `conversation_history` | `channel:, oldest:, latest:` | Fetch message history |
| `conversation_replies` | `channel:, ts:` | Fetch thread replies |
| `conversation_members` | `channel:` | List channel members |
| `join_conversation` | `channel:` | Join a channel |
| `leave_conversation` | `channel:` | Leave a channel |
| `invite_to_conversation` | `channel:, users:` | Invite users to a channel |
| `open_conversation` | `users:` | Open or resume a DM |
| `create_conversation` | `name:, is_private:` | Create a channel |
| `archive_conversation` | `channel:` | Archive a channel |
| `set_conversation_topic` | `channel:, topic:` | Set the channel topic |

### Users

| Method | Key Parameters | Description |
|--------|---------------|-------------|
| `list_users` | `cursor:, limit:` | List workspace users |
| `user_info` | `user:` | Get user details |
| `lookup_by_email` | `email:` | Find user by email |
| `get_presence` | `user:` | Get presence status |
| `set_presence` | `presence:` | Set bot presence (`auto`/`away`) |

### Reactions

| Method | Key Parameters | Description |
|--------|---------------|-------------|
| `add_reaction` | `channel:, timestamp:, name:` | Add a reaction |
| `remove_reaction` | `channel:, timestamp:, name:` | Remove a reaction |
| `get_reactions` | `channel:, timestamp:` | Get reactions on a message |
| `list_reactions` | `user:, cursor:` | List reactions by a user |

### Files

| Method | Key Parameters | Description |
|--------|---------------|-------------|
| `upload_file` | `filename:, content:, channel:` | Upload via two-step external flow |
| `list_files` | `channel:, user:, types:` | List files |
| `file_info` | `file:` | Get file details |
| `delete_file` | `file:` | Delete a file |
| `share_file` | `file:` | Create a public URL for a file |

### Pins

| Method | Key Parameters | Description |
|--------|---------------|-------------|
| `add_pin` | `channel:, timestamp:` | Pin a message |
| `remove_pin` | `channel:, timestamp:` | Unpin a message |
| `list_pins` | `channel:` | List pinned items |

### Bookmarks

| Method | Key Parameters | Description |
|--------|---------------|-------------|
| `add_bookmark` | `channel:, title:, type:, link:` | Add a bookmark |
| `edit_bookmark` | `channel:, bookmark_id:` | Edit a bookmark |
| `remove_bookmark` | `channel:, bookmark_id:` | Remove a bookmark |
| `list_bookmarks` | `channel:` | List bookmarks |

### Reminders

| Method | Key Parameters | Description |
|--------|---------------|-------------|
| `add_reminder` | `text:, time:, user:` | Create a reminder |
| `complete_reminder` | `reminder:` | Mark complete |
| `delete_reminder` | `reminder:` | Delete a reminder |
| `reminder_info` | `reminder:` | Get reminder details |
| `list_reminders` | | List all reminders |

### Usergroups

| Method | Key Parameters | Description |
|--------|---------------|-------------|
| `list_usergroups` | `include_users:, include_disabled:` | List usergroups |
| `create_usergroup` | `name:, handle:` | Create a usergroup |
| `update_usergroup` | `usergroup:, name:` | Update a usergroup |
| `disable_usergroup` | `usergroup:` | Disable a usergroup |
| `enable_usergroup` | `usergroup:` | Re-enable a usergroup |
| `list_usergroup_users` | `usergroup:` | List members |
| `update_usergroup_users` | `usergroup:, users:` | Set members |

### Views

| Method | Key Parameters | Description |
|--------|---------------|-------------|
| `open_view` | `trigger_id:, view:` | Open a modal |
| `push_view` | `trigger_id:, view:` | Push a view onto the stack |
| `update_view` | `view_id:, view:` | Update an existing view |
| `publish_view` | `user_id:, view:` | Publish an App Home tab |

### Search

| Method | Key Parameters | Description |
|--------|---------------|-------------|
| `search_messages` | `query:, sort:, count:` | Search messages (requires user token) |
| `search_files` | `query:, sort:, count:` | Search files (requires user token) |

### Blocks (Builder)

Pure Ruby helpers for constructing Block Kit payloads. No HTTP calls.

| Method | Description |
|--------|-------------|
| `mrkdwn(text)` | Markdown text object |
| `plain_text(text)` | Plain text object |
| `option(text:, value:)` | Select menu option |
| `section(text:, accessory:, fields:)` | Section block |
| `divider` | Divider block |
| `header(text:)` | Header block |
| `context(elements:)` | Context block |
| `actions(elements:)` | Actions block |
| `image(image_url:, alt_text:)` | Image block |
| `input(label:, element:)` | Input block |
| `file_block(external_id:)` | File block |
| `button(text:, action_id:)` | Button element |
| `overflow_menu(action_id:, options:)` | Overflow menu |
| `static_select(action_id:, placeholder:, options:)` | Static select |
| `multi_static_select(action_id:, placeholder:, options:)` | Multi-select |
| `datepicker(action_id:)` | Date picker |

## Message Poller Actor

A configurable polling actor that watches channels for new messages. Disabled by default.

Configure via Legion::Settings:

```json
{
  "lex-slack": {
    "token": "xoxb-...",
    "poller": {
      "enabled": true,
      "interval": 30,
      "channels": ["C123ABC", "C456DEF"],
      "limit": 50
    }
  }
}
```

The poller uses an in-memory high-water mark per channel to avoid reprocessing messages. New messages are published to Legion transport if available.

## Requirements

- Ruby >= 3.4
- `faraday` >= 2.0

## License

MIT
