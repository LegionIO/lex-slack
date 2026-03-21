# frozen_string_literal: true

module Legion
  module Extensions
    module Slack
      module Runners
        module Pins
          include Helpers::Client

          def add_pin(channel:, timestamp:, token: nil, **)
            conn = api_connection(token: token, **)
            resp = conn.post('pins.add', { channel: channel, timestamp: timestamp })
            { ok: resp.body['ok'] }
          end

          def remove_pin(channel:, timestamp:, token: nil, **)
            conn = api_connection(token: token, **)
            resp = conn.post('pins.remove', { channel: channel, timestamp: timestamp })
            { ok: resp.body['ok'] }
          end

          def list_pins(channel:, token: nil, **)
            conn = api_connection(token: token, **)
            resp = conn.get('pins.list', { channel: channel })
            { ok: resp.body['ok'], items: resp.body['items'] }
          end

          include Legion::Extensions::Helpers::Lex if defined?(Legion::Extensions::Helpers::Lex)
        end
      end
    end
  end
end
