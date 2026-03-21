# frozen_string_literal: true

module Legion
  module Extensions
    module Slack
      module Runners
        module Bookmarks
          include Helpers::Client

          def add_bookmark(channel:, title:, type:, token: nil, link: nil, emoji: nil, **)
            payload = { channel_id: channel, title: title, type: type }
            payload[:link] = link if link
            payload[:emoji] = emoji if emoji
            conn = api_connection(token: token, **)
            resp = conn.post('bookmarks.add', payload)
            { ok: resp.body['ok'], bookmark: resp.body['bookmark'] }
          end

          def edit_bookmark(channel:, bookmark_id:, token: nil, title: nil, link: nil, emoji: nil, **)
            payload = { channel_id: channel, bookmark_id: bookmark_id }
            payload[:title] = title if title
            payload[:link] = link if link
            payload[:emoji] = emoji if emoji
            conn = api_connection(token: token, **)
            resp = conn.post('bookmarks.edit', payload)
            { ok: resp.body['ok'], bookmark: resp.body['bookmark'] }
          end

          def remove_bookmark(channel:, bookmark_id:, token: nil, **)
            conn = api_connection(token: token, **)
            resp = conn.post('bookmarks.remove', { channel_id: channel, bookmark_id: bookmark_id })
            { ok: resp.body['ok'] }
          end

          def list_bookmarks(channel:, token: nil, **)
            conn = api_connection(token: token, **)
            resp = conn.get('bookmarks.list', { channel_id: channel })
            { ok: resp.body['ok'], bookmarks: resp.body['bookmarks'] }
          end

          include Legion::Extensions::Helpers::Lex if defined?(Legion::Extensions::Helpers::Lex)
        end
      end
    end
  end
end
