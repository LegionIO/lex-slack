# frozen_string_literal: true

module Legion
  module Extensions
    module Slack
      module Runners
        module Reminders
          include Helpers::Client

          def add_reminder(text:, time:, token: nil, user: nil, **)
            payload = { text: text, time: time }
            payload[:user] = user if user
            conn = api_connection(token: token, **)
            resp = conn.post('reminders.add', payload)
            { ok: resp.body['ok'], reminder: resp.body['reminder'] }
          end

          def complete_reminder(reminder:, token: nil, **)
            conn = api_connection(token: token, **)
            resp = conn.post('reminders.complete', { reminder: reminder })
            { ok: resp.body['ok'] }
          end

          def delete_reminder(reminder:, token: nil, **)
            conn = api_connection(token: token, **)
            resp = conn.post('reminders.delete', { reminder: reminder })
            { ok: resp.body['ok'] }
          end

          def reminder_info(reminder:, token: nil, **)
            conn = api_connection(token: token, **)
            resp = conn.get('reminders.info', { reminder: reminder })
            { ok: resp.body['ok'], reminder: resp.body['reminder'] }
          end

          def list_reminders(token: nil, **)
            conn = api_connection(token: token, **)
            resp = conn.get('reminders.list', {})
            { ok: resp.body['ok'], reminders: resp.body['reminders'] }
          end

          include Legion::Extensions::Helpers::Lex if defined?(Legion::Extensions::Helpers::Lex)
        end
      end
    end
  end
end
