# frozen_string_literal: true

module Legion
  module Extensions
    module Slack
      module Runners
        module Chat
          include Helpers::Client

          def post_message(channel:, text:, token: nil, blocks: nil, thread_ts: nil, unfurl_links: nil, **)
            payload = { channel: channel, text: text }
            payload[:blocks] = blocks if blocks
            payload[:thread_ts] = thread_ts if thread_ts
            payload[:unfurl_links] = unfurl_links unless unfurl_links.nil?
            conn = api_connection(token: token, **)
            resp = conn.post('chat.postMessage', payload)
            { ok: resp.body['ok'], ts: resp.body['ts'], channel: resp.body['channel'],
              message: resp.body['message'] }
          end

          def send_webhook(message:, webhook:, **)
            conn = webhook_connection(**)
            resp = conn.post(webhook, { text: message })
            { success: resp.body.nil? || resp.body == 'ok' || resp.body == {}, body: resp.body }
          end

          def update_message(channel:, ts:, token: nil, text: nil, blocks: nil, **)
            payload = { channel: channel, ts: ts }
            payload[:text] = text if text
            payload[:blocks] = blocks if blocks
            conn = api_connection(token: token, **)
            resp = conn.post('chat.update', payload)
            { ok: resp.body['ok'], ts: resp.body['ts'], channel: resp.body['channel'] }
          end

          def delete_message(channel:, ts:, token: nil, **)
            conn = api_connection(token: token, **)
            resp = conn.post('chat.delete', { channel: channel, ts: ts })
            { ok: resp.body['ok'] }
          end

          def schedule_message(channel:, text:, post_at:, token: nil, blocks: nil, **)
            payload = { channel: channel, text: text, post_at: post_at }
            payload[:blocks] = blocks if blocks
            conn = api_connection(token: token, **)
            resp = conn.post('chat.scheduleMessage', payload)
            { ok: resp.body['ok'], scheduled_message_id: resp.body['scheduled_message_id'],
              post_at: resp.body['post_at'] }
          end

          def delete_scheduled(channel:, scheduled_message_id:, token: nil, **)
            conn = api_connection(token: token, **)
            resp = conn.post('chat.deleteScheduledMessage',
                             { channel: channel, scheduled_message_id: scheduled_message_id })
            { ok: resp.body['ok'] }
          end

          include Legion::Extensions::Helpers::Lex if defined?(Legion::Extensions::Helpers::Lex)
        end
      end
    end
  end
end
