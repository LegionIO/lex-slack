require 'faraday'
require 'faraday_middleware'

module Legion
  module Extensions
    module Slack
      module Helpers
        module Client
          def client(**)
            Faraday.new(
              url:     'https://hooks.slack.com',
              headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' }
            ) do |connection|
              connection.request :json
              connection.response :json, content_type: /\bjson$/
            end
          end
        end
      end
    end
  end
end
