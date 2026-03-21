# frozen_string_literal: true

RSpec.describe Legion::Extensions::Slack::Runners::Pins do
  let(:test_obj) { Object.new.extend(described_class) }
  let(:mock_conn) { instance_double(Faraday::Connection) }

  before do
    allow(test_obj).to receive(:api_connection).and_return(mock_conn)
  end

  describe '#add_pin' do
    it 'calls pins.add' do
      allow(mock_conn).to receive(:post).with('pins.add', hash_including(channel: 'C1', timestamp: '1.0'))
                                        .and_return(double(body: { 'ok' => true }))
      result = test_obj.add_pin(token: 'xoxb', channel: 'C1', timestamp: '1.0')
      expect(result[:ok]).to be true
    end
  end

  describe '#remove_pin' do
    it 'calls pins.remove' do
      allow(mock_conn).to receive(:post).with('pins.remove', hash_including(channel: 'C1', timestamp: '1.0'))
                                        .and_return(double(body: { 'ok' => true }))
      result = test_obj.remove_pin(token: 'xoxb', channel: 'C1', timestamp: '1.0')
      expect(result[:ok]).to be true
    end
  end

  describe '#list_pins' do
    it 'calls pins.list' do
      allow(mock_conn).to receive(:get).with('pins.list', { channel: 'C1' })
                                       .and_return(double(body: { 'ok' => true, 'items' => [] }))
      result = test_obj.list_pins(token: 'xoxb', channel: 'C1')
      expect(result[:ok]).to be true
      expect(result[:items]).to eq([])
    end

    it 'returns items from response' do
      items = [{ 'type' => 'message' }]
      allow(mock_conn).to receive(:get).with('pins.list', { channel: 'C1' })
                                       .and_return(double(body: { 'ok' => true, 'items' => items }))
      result = test_obj.list_pins(token: 'xoxb', channel: 'C1')
      expect(result[:items]).to eq(items)
    end
  end
end
