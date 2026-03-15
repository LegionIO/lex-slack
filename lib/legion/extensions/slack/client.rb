# frozen_string_literal: true

require_relative 'helpers/client'
require_relative 'runners/chat'
require_relative 'runners/user'

module Legion
  module Extensions
    module Slack
      class Client
        include Helpers::Client
        include Runners::Chat
        include Runners::User

        attr_reader :opts

        def initialize(webhook: nil, token: nil, **extra)
          @opts = { webhook: webhook, token: token, **extra }.compact
        end

        def client(**override)
          super(**@opts, **override)
        end
      end
    end
  end
end
