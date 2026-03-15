# frozen_string_literal: true

require 'spec_helper'
require 'faraday'
require 'legion/extensions/slack/helpers/client'

RSpec.describe Legion::Extensions::Slack::Helpers::Client do
  let(:host) do
    klass = Class.new do
      include Legion::Extensions::Slack::Helpers::Client
    end
    klass.new
  end

  describe '#client' do
    it 'returns a Faraday::Connection' do
      expect(host.client).to be_a(Faraday::Connection)
    end

    it 'targets https://hooks.slack.com' do
      expect(host.client.url_prefix.to_s).to include('hooks.slack.com')
    end

    it 'sets Content-Type to application/json' do
      headers = host.client.headers
      expect(headers['Content-Type']).to eq('application/json')
    end

    it 'sets Accept to application/json' do
      headers = host.client.headers
      expect(headers['Accept']).to eq('application/json')
    end

    it 'returns a new connection on each call' do
      first  = host.client
      second = host.client
      expect(first).not_to be(second)
    end
  end
end
