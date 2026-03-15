# frozen_string_literal: true

require 'spec_helper'
require 'json'
require 'faraday'
require 'legion/extensions/slack/helpers/client'

# Stub framework helpers required at load time
unless defined?(Legion::Extensions::Helpers::Lex)
  module Legion
    module Extensions
      module Helpers
        module Lex
          def self.included(base)
            base.extend base if base.instance_of?(Module)
          end
        end
      end
    end
  end
end

require 'legion/extensions/slack/runners/chat'

# rubocop:disable Metrics/BlockLength
RSpec.describe Legion::Extensions::Slack::Runners::Chat do
  let(:faraday_response) { instance_double(Faraday::Response, success?: true, body: 'ok') }
  let(:faraday_client)   { instance_double(Faraday::Connection) }

  let(:runner) do
    klass = Class.new do
      include Legion::Extensions::Slack::Runners::Chat

      def client(**)
        nil # overridden per-test via stub
      end
    end
    klass.new
  end

  before do
    allow(runner).to receive(:client).and_return(faraday_client)
    allow(faraday_client).to receive(:post).and_return(faraday_response)
  end

  describe '#send' do
    let(:message) { 'Hello from Legion!' }
    let(:webhook) { '/services/T123/B456/xyz' }

    it 'posts to the webhook path' do
      runner.send(message: message, webhook: webhook)
      expect(faraday_client).to have_received(:post).with(webhook, anything)
    end

    it 'sends the message as JSON body with text key' do
      runner.send(message: message, webhook: webhook)
      expect(faraday_client).to have_received(:post).with(anything, { text: message }.to_json)
    end

    it 'returns a hash with success key' do
      result = runner.send(message: message, webhook: webhook)
      expect(result).to have_key(:success)
    end

    it 'returns success: true when the response is successful' do
      allow(faraday_response).to receive(:success?).and_return(true)
      result = runner.send(message: message, webhook: webhook)
      expect(result[:success]).to be(true)
    end

    it 'returns success: false when the response is not successful' do
      allow(faraday_response).to receive(:success?).and_return(false)
      result = runner.send(message: message, webhook: webhook)
      expect(result[:success]).to be(false)
    end

    it 'returns the response body' do
      allow(faraday_response).to receive(:body).and_return('ok')
      result = runner.send(message: message, webhook: webhook)
      expect(result[:body]).to eq('ok')
    end

    it 'ignores extra keyword arguments' do
      expect { runner.send(message: message, webhook: webhook, extra: 'ignored') }.not_to raise_error
    end
  end
end
# rubocop:enable Metrics/BlockLength
