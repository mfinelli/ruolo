# frozen_string_literal: true

require 'rspec'

require 'ruolo/configuration'

RSpec.describe Ruolo::Configuration do
  describe '#initialize' do
    it 'defaults to no connection' do
      expect(described_class.new.connection).to be_nil
    end

    it 'defaults to a generic user class' do
      expect(described_class.new.user_class).to eq('User')
    end
  end
end
