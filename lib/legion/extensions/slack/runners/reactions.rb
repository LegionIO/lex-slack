# frozen_string_literal: true

module Legion
  module Extensions
    module Slack
      module Runners
        module Reactions
          include Helpers::Client

          def add_reaction(channel:, timestamp:, name:, token: nil, **)
            conn = api_connection(token: token, **)
            resp = conn.post('reactions.add', { channel: channel, timestamp: timestamp, name: name })
            { ok: resp.body['ok'] }
          end

          def remove_reaction(channel:, timestamp:, name:, token: nil, **)
            conn = api_connection(token: token, **)
            resp = conn.post('reactions.remove', { channel: channel, timestamp: timestamp, name: name })
            { ok: resp.body['ok'] }
          end

          def get_reactions(channel:, timestamp:, token: nil, **)
            conn = api_connection(token: token, **)
            resp = conn.get('reactions.get', { channel: channel, timestamp: timestamp })
            { ok: resp.body['ok'], message: resp.body['message'] }
          end

          def list_reactions(token: nil, user: nil, cursor: nil, limit: 100, **)
            params = { limit: limit }
            params[:user] = user if user
            params[:cursor] = cursor if cursor
            conn = api_connection(token: token, **)
            resp = conn.get('reactions.list', params)
            { ok: resp.body['ok'], items: resp.body['items'],
              response_metadata: resp.body['response_metadata'] }
          end

          include Legion::Extensions::Helpers::Lex if defined?(Legion::Extensions::Helpers::Lex)
        end
      end
    end
  end
end
