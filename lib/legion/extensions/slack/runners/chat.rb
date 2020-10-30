require 'json'

module Legion
  module Extensions
    module Slack
      module Runners
        module Chat
          extend Legion::Extensions::Slack::Helpers::Client

          def send(message:, webhook:, **)
            body = { text: message }.to_json

            response = client.post(webhook, body)
            { success: response.success?, body: response.body }
          end

          include Legion::Extensions::Helpers::Lex
        end
      end
    end
  end
end
