module Legion
  module Extensions
    module Slack
      module Runners
        module Chat
          def send(message:, **opts); end

          def delete(**opts); end

          def me_message(**opts); end

          def send_ephemeral(message:, **opts); end

          def schedule(message:, **opts); end
        end
      end
    end
  end
end
