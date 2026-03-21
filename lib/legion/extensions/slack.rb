# frozen_string_literal: true

require 'legion/extensions/slack/version'
require 'legion/extensions/slack/helpers/client'

module Legion
  module Extensions
    module Slack
      extend Legion::Extensions::Core if Legion::Extensions.const_defined? :Core
    end
  end
end
