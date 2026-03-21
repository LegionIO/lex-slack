# frozen_string_literal: true

require_relative 'helpers/client'
require_relative 'runners/blocks'
require_relative 'runners/chat'
require_relative 'runners/conversations'
require_relative 'runners/users'
require_relative 'runners/reactions'
require_relative 'runners/files'
require_relative 'runners/pins'
require_relative 'runners/bookmarks'
require_relative 'runners/reminders'
require_relative 'runners/usergroups'
require_relative 'runners/views'
require_relative 'runners/search'

module Legion
  module Extensions
    module Slack
      class Client
        include Helpers::Client
        include Runners::Blocks
        include Runners::Chat
        include Runners::Conversations
        include Runners::Users
        include Runners::Reactions
        include Runners::Files
        include Runners::Pins
        include Runners::Bookmarks
        include Runners::Reminders
        include Runners::Usergroups
        include Runners::Views
        include Runners::Search

        attr_reader :opts

        def initialize(token: nil, webhook: nil, **extra)
          @opts = { token: token, webhook: webhook, **extra }.compact
        end

        def api_connection(**override)
          super(**@opts, **override)
        end

        def webhook_connection(**override)
          super(**@opts, **override)
        end
      end
    end
  end
end
