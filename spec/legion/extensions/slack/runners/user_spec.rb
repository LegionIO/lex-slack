# frozen_string_literal: true

require 'spec_helper'
require 'legion/extensions/slack/runners/user'

RSpec.describe Legion::Extensions::Slack::Runners::User do
  it 'is a module' do
    expect(described_class).to be_a(Module)
  end

  it 'can be included in a class without error' do
    expect do
      Class.new { include Legion::Extensions::Slack::Runners::User }
    end.not_to raise_error
  end
end
