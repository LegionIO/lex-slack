# frozen_string_literal: true

module Legion
  module Extensions
    module Slack
      module Runners
        module Files
          include Helpers::Client

          def upload_file(filename:, content:, token: nil, channel: nil, title: nil, **)
            conn = api_connection(token: token, **)
            url_resp = conn.get('files.getUploadURLExternal',
                                { filename: filename, length: content.bytesize })
            upload_url = url_resp.body['upload_url']
            file_id = url_resp.body['file_id']
            Faraday.put(upload_url, content, { 'Content-Type' => 'application/octet-stream' })
            complete_payload = { files: [{ id: file_id, title: title || filename }] }
            complete_payload[:channel_id] = channel if channel
            complete_resp = conn.post('files.completeUploadExternal', complete_payload)
            { ok: complete_resp.body['ok'], files: complete_resp.body['files'] }
          end

          def list_files(token: nil, channel: nil, user: nil, types: nil, cursor: nil, limit: 100, **)
            params = { limit: limit }
            params[:channel] = channel if channel
            params[:user] = user if user
            params[:types] = types if types
            params[:cursor] = cursor if cursor
            conn = api_connection(token: token, **)
            resp = conn.get('files.list', params)
            { ok: resp.body['ok'], files: resp.body['files'] }
          end

          def file_info(file:, token: nil, **)
            conn = api_connection(token: token, **)
            resp = conn.get('files.info', { file: file })
            { ok: resp.body['ok'], file: resp.body['file'] }
          end

          def delete_file(file:, token: nil, **)
            conn = api_connection(token: token, **)
            resp = conn.post('files.delete', { file: file })
            { ok: resp.body['ok'] }
          end

          def share_file(file:, token: nil, **)
            conn = api_connection(token: token, **)
            resp = conn.post('files.sharedPublicURL', { file: file })
            { ok: resp.body['ok'], file: resp.body['file'] }
          end

          include Legion::Extensions::Helpers::Lex if defined?(Legion::Extensions::Helpers::Lex)
        end
      end
    end
  end
end
