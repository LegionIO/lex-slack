# frozen_string_literal: true

module Legion
  module Extensions
    module Slack
      module Runners
        module Usergroups
          include Helpers::Client

          def list_usergroups(token: nil, include_users: false, include_disabled: false, **)
            conn = api_connection(token: token, **)
            resp = conn.get('usergroups.list',
                            { include_users: include_users, include_disabled: include_disabled })
            { ok: resp.body['ok'], usergroups: resp.body['usergroups'] }
          end

          def create_usergroup(name:, token: nil, handle: nil, description: nil, channels: nil, **)
            payload = { name: name }
            payload[:handle] = handle if handle
            payload[:description] = description if description
            payload[:channels] = channels if channels
            conn = api_connection(token: token, **)
            resp = conn.post('usergroups.create', payload)
            { ok: resp.body['ok'], usergroup: resp.body['usergroup'] }
          end

          def update_usergroup(usergroup:, token: nil, name: nil, handle: nil, description: nil, channels: nil, **)
            payload = { usergroup: usergroup }
            payload[:name] = name if name
            payload[:handle] = handle if handle
            payload[:description] = description if description
            payload[:channels] = channels if channels
            conn = api_connection(token: token, **)
            resp = conn.post('usergroups.update', payload)
            { ok: resp.body['ok'], usergroup: resp.body['usergroup'] }
          end

          def disable_usergroup(usergroup:, token: nil, **)
            conn = api_connection(token: token, **)
            resp = conn.post('usergroups.disable', { usergroup: usergroup })
            { ok: resp.body['ok'], usergroup: resp.body['usergroup'] }
          end

          def enable_usergroup(usergroup:, token: nil, **)
            conn = api_connection(token: token, **)
            resp = conn.post('usergroups.enable', { usergroup: usergroup })
            { ok: resp.body['ok'], usergroup: resp.body['usergroup'] }
          end

          def list_usergroup_users(usergroup:, token: nil, **)
            conn = api_connection(token: token, **)
            resp = conn.get('usergroups.users.list', { usergroup: usergroup })
            { ok: resp.body['ok'], users: resp.body['users'] }
          end

          def update_usergroup_users(usergroup:, users:, token: nil, **)
            conn = api_connection(token: token, **)
            resp = conn.post('usergroups.users.update', { usergroup: usergroup, users: users })
            { ok: resp.body['ok'], usergroup: resp.body['usergroup'] }
          end

          include Legion::Extensions::Helpers::Lex if defined?(Legion::Extensions::Helpers::Lex)
        end
      end
    end
  end
end
