# frozen_string_literal: true

RSpec.describe Legion::Extensions::Slack::Runners::Users do
  let(:test_obj) { Object.new.extend(described_class) }
  let(:mock_conn) { instance_double(Faraday::Connection) }

  before do
    allow(test_obj).to receive(:api_connection).and_return(mock_conn)
  end

  describe '#list_users' do
    it 'calls users.list' do
      allow(mock_conn).to receive(:get).with('users.list', hash_including(limit: 200))
                                       .and_return(double(body: { 'ok' => true, 'members' => [],
                                                                  'response_metadata' => {} }))
      result = test_obj.list_users(token: 'xoxb')
      expect(result[:ok]).to be true
      expect(result[:members]).to eq([])
    end

    it 'includes cursor when provided' do
      allow(mock_conn).to receive(:get).with('users.list', hash_including(cursor: 'abc'))
                                       .and_return(double(body: { 'ok' => true, 'members' => [],
                                                                  'response_metadata' => {} }))
      result = test_obj.list_users(token: 'xoxb', cursor: 'abc')
      expect(result[:ok]).to be true
    end
  end

  describe '#user_info' do
    it 'calls users.info' do
      allow(mock_conn).to receive(:get).with('users.info', { user: 'U123' })
                                       .and_return(double(body: { 'ok' => true, 'user' => { 'id' => 'U123' } }))
      result = test_obj.user_info(token: 'xoxb', user: 'U123')
      expect(result[:ok]).to be true
      expect(result[:user]).to include('id' => 'U123')
    end
  end

  describe '#lookup_by_email' do
    it 'calls users.lookupByEmail' do
      allow(mock_conn).to receive(:get).with('users.lookupByEmail', { email: 'user@example.com' })
                                       .and_return(double(body: { 'ok' => true, 'user' => { 'id' => 'U1' } }))
      result = test_obj.lookup_by_email(token: 'xoxb', email: 'user@example.com')
      expect(result[:ok]).to be true
      expect(result[:user]).to include('id' => 'U1')
    end
  end

  describe '#get_presence' do
    it 'calls users.getPresence' do
      allow(mock_conn).to receive(:get).with('users.getPresence', { user: 'U1' })
                                       .and_return(double(body: { 'ok' => true, 'presence' => 'active' }))
      result = test_obj.get_presence(token: 'xoxb', user: 'U1')
      expect(result[:ok]).to be true
      expect(result[:presence]).to eq('active')
    end
  end

  describe '#set_presence' do
    it 'calls users.setPresence' do
      allow(mock_conn).to receive(:post).with('users.setPresence', { presence: 'auto' })
                                        .and_return(double(body: { 'ok' => true }))
      result = test_obj.set_presence(token: 'xoxb', presence: 'auto')
      expect(result[:ok]).to be true
    end

    it 'accepts away presence' do
      allow(mock_conn).to receive(:post).with('users.setPresence', { presence: 'away' })
                                        .and_return(double(body: { 'ok' => true }))
      result = test_obj.set_presence(token: 'xoxb', presence: 'away')
      expect(result[:ok]).to be true
    end
  end
end
