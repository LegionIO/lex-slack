# frozen_string_literal: true

module Legion
  module Extensions
    module Slack
      module Runners
        module Search
          include Helpers::Client

          def search_messages(query:, token: nil, sort: nil, sort_dir: nil, cursor: nil, count: 20, **)
            params = { query: query, count: count }
            params[:sort] = sort if sort
            params[:sort_dir] = sort_dir if sort_dir
            params[:cursor] = cursor if cursor
            conn = api_connection(token: token, **)
            resp = conn.get('search.messages', params)
            { ok: resp.body['ok'], messages: resp.body['messages'] }
          end

          def search_files(query:, token: nil, sort: nil, sort_dir: nil, cursor: nil, count: 20, **)
            params = { query: query, count: count }
            params[:sort] = sort if sort
            params[:sort_dir] = sort_dir if sort_dir
            params[:cursor] = cursor if cursor
            conn = api_connection(token: token, **)
            resp = conn.get('search.files', params)
            { ok: resp.body['ok'], files: resp.body['files'] }
          end

          include Legion::Extensions::Helpers::Lex if defined?(Legion::Extensions::Helpers::Lex)
        end
      end
    end
  end
end
