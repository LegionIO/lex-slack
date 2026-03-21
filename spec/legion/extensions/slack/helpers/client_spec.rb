# frozen_string_literal: true

RSpec.describe Legion::Extensions::Slack::Helpers::Client do
  let(:test_obj) { Object.new.extend(described_class) }

  describe '#api_connection' do
    it 'returns a Faraday::Connection' do
      conn = test_obj.api_connection
      expect(conn).to be_a(Faraday::Connection)
    end

    it 'targets https://slack.com/api/ by default' do
      conn = test_obj.api_connection
      expect(conn.url_prefix.to_s).to eq('https://slack.com/api/')
    end

    it 'sets Authorization header when token provided' do
      conn = test_obj.api_connection(token: 'xoxb-test')
      expect(conn.headers['Authorization']).to eq('Bearer xoxb-test')
    end

    it 'omits Authorization header when no token' do
      conn = test_obj.api_connection
      expect(conn.headers['Authorization']).to be_nil
    end

    it 'allows base_url override' do
      conn = test_obj.api_connection(base_url: 'https://custom.slack.com/api/')
      expect(conn.url_prefix.to_s).to eq('https://custom.slack.com/api/')
    end
  end

  describe '#webhook_connection' do
    it 'returns a Faraday::Connection' do
      conn = test_obj.webhook_connection
      expect(conn).to be_a(Faraday::Connection)
    end

    it 'targets https://hooks.slack.com by default' do
      conn = test_obj.webhook_connection
      expect(conn.url_prefix.to_s).to eq('https://hooks.slack.com/')
    end

    it 'allows base_url override' do
      conn = test_obj.webhook_connection(base_url: 'https://custom.hooks.slack.com')
      expect(conn.url_prefix.to_s).to eq('https://custom.hooks.slack.com/')
    end

    it 'does not set Authorization header' do
      conn = test_obj.webhook_connection
      expect(conn.headers['Authorization']).to be_nil
    end
  end
end
