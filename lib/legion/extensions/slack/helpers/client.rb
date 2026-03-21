# frozen_string_literal: true

require 'faraday'

module Legion
  module Extensions
    module Slack
      module Helpers
        module Client
          def api_connection(token: nil, base_url: 'https://slack.com/api/', **)
            Faraday.new(url: base_url) do |conn|
              conn.request :json
              conn.response :json, content_type: /\bjson$/
              conn.headers['Authorization'] = "Bearer #{token}" if token
              conn.adapter Faraday.default_adapter
            end
          end

          def webhook_connection(base_url: 'https://hooks.slack.com', **)
            Faraday.new(url: base_url) do |conn|
              conn.request :json
              conn.response :json, content_type: /\bjson$/
              conn.adapter Faraday.default_adapter
            end
          end
        end
      end
    end
  end
end
