# frozen_string_literal: true

module Legion
  module Extensions
    module Slack
      module Runners
        module Users
          include Helpers::Client

          def list_users(token: nil, cursor: nil, limit: 200, **)
            params = { limit: limit }
            params[:cursor] = cursor if cursor
            conn = api_connection(token: token, **)
            resp = conn.get('users.list', params)
            { ok: resp.body['ok'], members: resp.body['members'],
              response_metadata: resp.body['response_metadata'] }
          end

          def user_info(user:, token: nil, **)
            conn = api_connection(token: token, **)
            resp = conn.get('users.info', { user: user })
            { ok: resp.body['ok'], user: resp.body['user'] }
          end

          def lookup_by_email(email:, token: nil, **)
            conn = api_connection(token: token, **)
            resp = conn.get('users.lookupByEmail', { email: email })
            { ok: resp.body['ok'], user: resp.body['user'] }
          end

          def get_presence(user:, token: nil, **)
            conn = api_connection(token: token, **)
            resp = conn.get('users.getPresence', { user: user })
            { ok: resp.body['ok'], presence: resp.body['presence'] }
          end

          def set_presence(presence:, token: nil, **)
            conn = api_connection(token: token, **)
            resp = conn.post('users.setPresence', { presence: presence })
            { ok: resp.body['ok'] }
          end

          include Legion::Extensions::Helpers::Lex if defined?(Legion::Extensions::Helpers::Lex)
        end
      end
    end
  end
end
