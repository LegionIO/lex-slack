module Legion
  module Extensions
    module Slack
      module Runners
        module User
          def list(**opts); end

          def delete_photo(**opts); end

          def identity(**opts); end

          def info(**opts); end

          def set_active(**opts); end

          def set_presence(**opts); end

          def get_presence(**opts); end

          def set_photo(**opts); end
        end
      end
    end
  end
end
