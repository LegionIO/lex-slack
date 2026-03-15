# frozen_string_literal: true

RSpec.describe Legion::Extensions::Slack::Client do
  describe '#initialize' do
    it 'stores webhook option' do
      client = described_class.new(webhook: '/services/T00/B00/xxx')
      expect(client.opts).to include(webhook: '/services/T00/B00/xxx')
    end

    it 'stores token option' do
      client = described_class.new(token: 'xoxb-test-token')
      expect(client.opts).to include(token: 'xoxb-test-token')
    end
  end

  describe 'runner methods' do
    let(:client) { described_class.new(token: 'xoxb-test', webhook: '/test') }

    it 'responds to chat methods' do
      expect(client).to respond_to(:send)
    end

    it 'responds to user methods' do
      expect(client).to respond_to(:list_users, :user_info, :set_presence, :get_presence)
    end
  end
end
