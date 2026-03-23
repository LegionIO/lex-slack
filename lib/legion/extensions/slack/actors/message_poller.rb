# frozen_string_literal: true

module Legion
  module Extensions
    module Slack
      module Actor
        class MessagePoller
          include Helpers::Client
          include Legion::Logging::Helper

          def initialize
            @hwm = {}
          end

          def run
            return unless enabled?
            return if channels.empty?

            token = settings.dig('lex-slack', 'token')
            limit = settings.dig('lex-slack', 'poller', 'limit') || 50

            channels.each do |channel_id|
              poll_channel(channel_id, token: token, limit: limit)
            end
          end

          def interval
            settings.dig('lex-slack', 'poller', 'interval') || 30
          end

          private

          def enabled?
            settings.dig('lex-slack', 'poller', 'enabled') == true
          end

          def channels
            settings.dig('lex-slack', 'poller', 'channels') || []
          end

          def poll_channel(channel_id, token:, limit:)
            params = { channel: channel_id, limit: limit }
            params[:oldest] = @hwm[channel_id] if @hwm[channel_id]

            conn = api_connection(token: token)
            resp = conn.get('conversations.history', params)
            body = resp.body
            return unless body['ok']

            messages = body['messages'] || []
            return if messages.empty?

            @hwm[channel_id] = messages.map { |m| m['ts'] }.max
            messages.each { |msg| publish_message(channel_id, msg) }
          end

          def publish_message(channel_id, message)
            if defined?(Legion::Transport::Message)
              Legion::Transport::Message.new(
                function:  'handle_message',
                namespace: 'Legion::Extensions::Slack',
                args:      { channel: channel_id, message: message }
              )
            else
              log.info "Slack message in #{channel_id}: #{message['text']}"
            end
          rescue StandardError => e
            log.warn "Failed to publish slack message: #{e.message}"
          end

          def settings
            return Legion::Settings.to_h if defined?(Legion::Settings)

            {}
          end
        end
      end
    end
  end
end
