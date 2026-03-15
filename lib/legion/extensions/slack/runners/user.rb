# frozen_string_literal: true

module Legion
  module Extensions
    module Slack
      module Runners
        module User
          def list_users(token:, cursor: nil, limit: 200, **)
            conn = api_connection(token: token)
            params = { limit: limit }
            params[:cursor] = cursor if cursor
            resp = conn.get('users.list', params)
            { ok: resp.body['ok'], members: resp.body['members'], response_metadata: resp.body['response_metadata'] }
          end

          def user_info(token:, user_id:, **)
            conn = api_connection(token: token)
            resp = conn.get('users.info', { user: user_id })
            { ok: resp.body['ok'], user: resp.body['user'] }
          end

          def set_presence(token:, presence:, **)
            conn = api_connection(token: token)
            resp = conn.post('users.setPresence', { presence: presence })
            { ok: resp.body['ok'] }
          end

          def get_presence(token:, user_id:, **)
            conn = api_connection(token: token)
            resp = conn.get('users.getPresence', { user: user_id })
            { ok: resp.body['ok'], presence: resp.body['presence'] }
          end

          private

          def api_connection(token:, **)
            Faraday.new(url: 'https://slack.com/api/') do |conn|
              conn.request :json
              conn.response :json, content_type: /\bjson$/
              conn.headers['Authorization'] = "Bearer #{token}"
              conn.adapter Faraday.default_adapter
            end
          end
        end
      end
    end
  end
end
