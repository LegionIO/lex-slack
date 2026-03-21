# frozen_string_literal: true

RSpec.describe Legion::Extensions::Slack::Client do
  let(:mock_conn) { instance_double(Faraday::Connection) }

  before do
    allow(Faraday).to receive(:new).and_return(mock_conn)
  end

  describe '#initialize' do
    it 'stores token in opts' do
      client = described_class.new(token: 'xoxb-test')
      expect(client.opts[:token]).to eq('xoxb-test')
    end

    it 'stores webhook in opts' do
      client = described_class.new(webhook: '/services/T/B/X')
      expect(client.opts[:webhook]).to eq('/services/T/B/X')
    end

    it 'compacts nil values' do
      client = described_class.new(token: 'xoxb-test', webhook: nil)
      expect(client.opts).not_to have_key(:webhook)
    end

    it 'accepts extra options' do
      client = described_class.new(token: 'xoxb-test', timeout: 30)
      expect(client.opts[:timeout]).to eq(30)
    end
  end

  describe 'chat operations' do
    let(:client) { described_class.new(token: 'xoxb-test') }

    it 'posts a message' do
      allow(mock_conn).to receive(:post).with('chat.postMessage',
                                              hash_including(channel: 'C1', text: 'Hello'))
                                        .and_return(double(body: { 'ok' => true, 'ts' => '1.0',
                                                                   'channel' => 'C1', 'message' => {} }))
      result = client.post_message(token: 'xoxb-test', channel: 'C1', text: 'Hello')
      expect(result[:ok]).to be true
    end

    it 'sends a webhook' do
      mock_wh_conn = instance_double(Faraday::Connection)
      allow(Faraday).to receive(:new).and_return(mock_wh_conn)
      allow(mock_wh_conn).to receive(:post).with('/services/T/B/X', { text: 'Alert!' })
                                           .and_return(double(body: 'ok'))
      client2 = described_class.new(webhook: '/services/T/B/X')
      result = client2.send_webhook(message: 'Alert!', webhook: '/services/T/B/X')
      expect(result).to have_key(:success)
    end
  end

  describe 'conversation operations' do
    let(:client) { described_class.new(token: 'xoxb-test') }

    it 'lists conversations' do
      allow(mock_conn).to receive(:get).with('conversations.list', hash_including(limit: 200))
                                       .and_return(double(body: { 'ok' => true, 'channels' => [],
                                                                  'response_metadata' => {} }))
      result = client.list_conversations(token: 'xoxb-test')
      expect(result[:ok]).to be true
    end
  end

  describe 'user operations' do
    let(:client) { described_class.new(token: 'xoxb-test') }

    it 'lists users' do
      allow(mock_conn).to receive(:get).with('users.list', hash_including(limit: 200))
                                       .and_return(double(body: { 'ok' => true, 'members' => [],
                                                                  'response_metadata' => {} }))
      result = client.list_users(token: 'xoxb-test')
      expect(result[:ok]).to be true
    end
  end

  describe 'block building' do
    let(:client) { described_class.new(token: 'xoxb-test') }

    it 'builds a section block' do
      result = client.section(text: 'Hello World')
      expect(result[:type]).to eq('section')
      expect(result[:text][:text]).to eq('Hello World')
    end

    it 'builds a divider' do
      expect(client.divider).to eq({ type: 'divider' })
    end
  end

  describe 'per-call token override' do
    let(:client) { described_class.new(token: 'xoxb-default') }

    it 'accepts override token at call site' do
      allow(mock_conn).to receive(:get).with('users.list', hash_including(limit: 200))
                                       .and_return(double(body: { 'ok' => true, 'members' => [],
                                                                  'response_metadata' => {} }))
      result = client.list_users(token: 'xoxb-override')
      expect(result[:ok]).to be true
    end
  end
end
