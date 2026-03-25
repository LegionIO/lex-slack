# frozen_string_literal: true

RSpec.describe Legion::Extensions::Slack::Actor::MessagePoller do
  let(:poller) { described_class.new }
  let(:mock_conn) { instance_double(Faraday::Connection) }

  before do
    allow(poller).to receive(:api_connection).and_return(mock_conn)
  end

  describe '#time' do
    it 'returns 30 when no settings' do
      allow(poller).to receive(:settings).and_return({})
      expect(poller.time).to eq(30)
    end

    it 'returns configured interval' do
      allow(poller).to receive(:settings).and_return({ 'lex-slack' => { 'poller' => { 'interval' => 60 } } })
      expect(poller.time).to eq(60)
    end
  end

  describe '#action' do
    it 'does nothing when disabled' do
      allow(poller).to receive(:settings).and_return(
        { 'lex-slack' => { 'poller' => { 'enabled' => false, 'channels' => ['C1'] } } }
      )
      expect(mock_conn).not_to receive(:get)
      poller.action
    end

    it 'does nothing when channels empty' do
      allow(poller).to receive(:settings).and_return(
        { 'lex-slack' => { 'poller' => { 'enabled' => true, 'channels' => [] } } }
      )
      expect(mock_conn).not_to receive(:get)
      poller.action
    end

    it 'does nothing when poller key missing' do
      allow(poller).to receive(:settings).and_return({})
      expect(mock_conn).not_to receive(:get)
      poller.action
    end

    it 'polls each channel when enabled' do
      allow(poller).to receive(:settings).and_return(
        { 'lex-slack' => { 'token' => 'xoxb', 'poller' => { 'enabled' => true,
                                                              'channels' => %w[C1 C2], 'limit' => 50 } } }
      )
      allow(mock_conn).to receive(:get).with('conversations.history', hash_including(channel: 'C1'))
                                       .and_return(double(body: { 'ok' => true, 'messages' => [] }))
      allow(mock_conn).to receive(:get).with('conversations.history', hash_including(channel: 'C2'))
                                       .and_return(double(body: { 'ok' => true, 'messages' => [] }))
      poller.action
      expect(mock_conn).to have_received(:get).twice
    end

    it 'tracks high water mark after polling' do
      allow(poller).to receive(:settings).and_return(
        { 'lex-slack' => { 'token' => 'xoxb', 'poller' => { 'enabled' => true,
                                                              'channels' => ['C1'], 'limit' => 10 } } }
      )
      messages = [{ 'ts' => '100.0', 'text' => 'Hello' }, { 'ts' => '200.0', 'text' => 'World' }]
      allow(mock_conn).to receive(:get).with('conversations.history', hash_including(channel: 'C1'))
                                       .and_return(double(body: { 'ok' => true, 'messages' => messages }))
      poller.action
      allow(mock_conn).to receive(:get).with('conversations.history',
                                             hash_including(oldest: '200.0'))
                                       .and_return(double(body: { 'ok' => true, 'messages' => [] }))
      poller.action
    end

    it 'handles api error gracefully' do
      allow(poller).to receive(:settings).and_return(
        { 'lex-slack' => { 'token' => 'xoxb', 'poller' => { 'enabled' => true,
                                                              'channels' => ['C1'], 'limit' => 10 } } }
      )
      allow(mock_conn).to receive(:get).and_return(double(body: { 'ok' => false }))
      expect { poller.action }.not_to raise_error
    end
  end
end
