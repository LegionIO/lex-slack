# frozen_string_literal: true

require 'legion/extensions/slack/version'
require 'legion/extensions/slack/helpers/client'
require 'legion/extensions/slack/runners/blocks'
require 'legion/extensions/slack/runners/chat'
require 'legion/extensions/slack/runners/conversations'
require 'legion/extensions/slack/runners/users'
require 'legion/extensions/slack/runners/reactions'
require 'legion/extensions/slack/runners/files'
require 'legion/extensions/slack/runners/pins'
require 'legion/extensions/slack/runners/bookmarks'
require 'legion/extensions/slack/runners/reminders'
require 'legion/extensions/slack/runners/usergroups'
require 'legion/extensions/slack/runners/views'
require 'legion/extensions/slack/runners/search'
require 'legion/extensions/slack/actors/message_poller'
require 'legion/extensions/slack/client'

module Legion
  module Extensions
    module Slack
      extend Legion::Extensions::Core if Legion::Extensions.const_defined? :Core
    end
  end
end
