# frozen_string_literal: true

module Legion
  module Extensions
    module Slack
      module Runners
        module Conversations
          include Helpers::Client

          def list_conversations(token: nil, types: nil, cursor: nil, limit: 200, **)
            params = { limit: limit }
            params[:types] = types if types
            params[:cursor] = cursor if cursor
            conn = api_connection(token: token, **)
            resp = conn.get('conversations.list', params)
            { ok: resp.body['ok'], channels: resp.body['channels'],
              response_metadata: resp.body['response_metadata'] }
          end

          def conversation_info(channel:, token: nil, **)
            conn = api_connection(token: token, **)
            resp = conn.get('conversations.info', { channel: channel })
            { ok: resp.body['ok'], channel: resp.body['channel'] }
          end

          def conversation_history(channel:, token: nil, cursor: nil, limit: 100, oldest: nil, latest: nil, **)
            params = { channel: channel, limit: limit }
            params[:cursor] = cursor if cursor
            params[:oldest] = oldest if oldest
            params[:latest] = latest if latest
            conn = api_connection(token: token, **)
            resp = conn.get('conversations.history', params)
            { ok: resp.body['ok'], messages: resp.body['messages'],
              has_more: resp.body['has_more'], response_metadata: resp.body['response_metadata'] }
          end

          def conversation_replies(channel:, ts:, token: nil, cursor: nil, limit: 100, **)
            params = { channel: channel, ts: ts, limit: limit }
            params[:cursor] = cursor if cursor
            conn = api_connection(token: token, **)
            resp = conn.get('conversations.replies', params)
            { ok: resp.body['ok'], messages: resp.body['messages'], has_more: resp.body['has_more'] }
          end

          def conversation_members(channel:, token: nil, cursor: nil, limit: 100, **)
            params = { channel: channel, limit: limit }
            params[:cursor] = cursor if cursor
            conn = api_connection(token: token, **)
            resp = conn.get('conversations.members', params)
            { ok: resp.body['ok'], members: resp.body['members'],
              response_metadata: resp.body['response_metadata'] }
          end

          def join_conversation(channel:, token: nil, **)
            conn = api_connection(token: token, **)
            resp = conn.post('conversations.join', { channel: channel })
            { ok: resp.body['ok'], channel: resp.body['channel'] }
          end

          def leave_conversation(channel:, token: nil, **)
            conn = api_connection(token: token, **)
            resp = conn.post('conversations.leave', { channel: channel })
            { ok: resp.body['ok'] }
          end

          def invite_to_conversation(channel:, users:, token: nil, **)
            conn = api_connection(token: token, **)
            resp = conn.post('conversations.invite', { channel: channel, users: users })
            { ok: resp.body['ok'], channel: resp.body['channel'] }
          end

          def open_conversation(token: nil, users: nil, channel: nil, **)
            payload = {}
            payload[:users] = users if users
            payload[:channel] = channel if channel
            conn = api_connection(token: token, **)
            resp = conn.post('conversations.open', payload)
            { ok: resp.body['ok'], channel: resp.body['channel'] }
          end

          def create_conversation(name:, token: nil, is_private: false, **)
            conn = api_connection(token: token, **)
            resp = conn.post('conversations.create', { name: name, is_private: is_private })
            { ok: resp.body['ok'], channel: resp.body['channel'] }
          end

          def archive_conversation(channel:, token: nil, **)
            conn = api_connection(token: token, **)
            resp = conn.post('conversations.archive', { channel: channel })
            { ok: resp.body['ok'] }
          end

          def set_conversation_topic(channel:, topic:, token: nil, **)
            conn = api_connection(token: token, **)
            resp = conn.post('conversations.setTopic', { channel: channel, topic: topic })
            { ok: resp.body['ok'], topic: resp.body['topic'] }
          end

          include Legion::Extensions::Helpers::Lex if defined?(Legion::Extensions::Helpers::Lex)
        end
      end
    end
  end
end
