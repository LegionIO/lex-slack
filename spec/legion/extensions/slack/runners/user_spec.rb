# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
RSpec.describe Legion::Extensions::Slack::Runners::User do
  let(:runner) { Object.new.extend(described_class) }
  let(:mock_conn) { instance_double(Faraday::Connection) }

  before do
    allow(Faraday).to receive(:new).and_return(mock_conn)
  end

  describe '#list_users' do
    it 'returns member list' do
      allow(mock_conn).to receive(:get).and_return(
        double(body: { 'ok' => true, 'members' => [{ 'id' => 'U1' }], 'response_metadata' => {} })
      )
      result = runner.list_users(token: 'xoxb-test')
      expect(result[:ok]).to be true
      expect(result[:members].size).to eq(1)
    end
  end

  describe '#user_info' do
    it 'returns user details' do
      allow(mock_conn).to receive(:get).and_return(
        double(body: { 'ok' => true, 'user' => { 'id' => 'U1', 'name' => 'test' } })
      )
      result = runner.user_info(token: 'xoxb-test', user_id: 'U1')
      expect(result[:ok]).to be true
      expect(result[:user]['name']).to eq('test')
    end
  end

  describe '#set_presence' do
    it 'sets user presence' do
      allow(mock_conn).to receive(:post).and_return(double(body: { 'ok' => true }))
      result = runner.set_presence(token: 'xoxb-test', presence: 'away')
      expect(result[:ok]).to be true
    end
  end

  describe '#get_presence' do
    it 'returns presence status' do
      allow(mock_conn).to receive(:get).and_return(
        double(body: { 'ok' => true, 'presence' => 'active' })
      )
      result = runner.get_presence(token: 'xoxb-test', user_id: 'U1')
      expect(result[:presence]).to eq('active')
    end
  end
end
# rubocop:enable Metrics/BlockLength
