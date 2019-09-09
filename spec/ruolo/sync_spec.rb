# frozen_string_literal: true

require 'rspec'

require 'ruolo/sync'

RSpec.describe Ruolo::Sync do
  describe '#initialize' do
    it 'returns a sync object' do
      expect(described_class.new(File.expand_path(File.join(__FILE__, '..', '..', 'fixtures', 'policies', 'empty.yml')))).to be_a(described_class)
    end
  end
end
