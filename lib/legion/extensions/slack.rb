require 'legion/extensions/slack/version'

module Legion
  module Extensions
    module Slack
      extend Legion::Extensions::Core if Legion::Extensions.const_defined? :Core
    end
  end
end
