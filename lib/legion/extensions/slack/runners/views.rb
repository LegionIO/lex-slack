# frozen_string_literal: true

module Legion
  module Extensions
    module Slack
      module Runners
        module Views
          include Helpers::Client

          def open_view(trigger_id:, view:, token: nil, **)
            conn = api_connection(token: token, **)
            resp = conn.post('views.open', { trigger_id: trigger_id, view: view })
            { ok: resp.body['ok'], view: resp.body['view'] }
          end

          def push_view(trigger_id:, view:, token: nil, **)
            conn = api_connection(token: token, **)
            resp = conn.post('views.push', { trigger_id: trigger_id, view: view })
            { ok: resp.body['ok'], view: resp.body['view'] }
          end

          def update_view(view_id:, view:, token: nil, hash: nil, **)
            payload = { view_id: view_id, view: view }
            payload[:hash] = hash if hash
            conn = api_connection(token: token, **)
            resp = conn.post('views.update', payload)
            { ok: resp.body['ok'], view: resp.body['view'] }
          end

          def publish_view(user_id:, view:, token: nil, **)
            conn = api_connection(token: token, **)
            resp = conn.post('views.publish', { user_id: user_id, view: view })
            { ok: resp.body['ok'], view: resp.body['view'] }
          end

          include Legion::Extensions::Helpers::Lex if defined?(Legion::Extensions::Helpers::Lex)
        end
      end
    end
  end
end
