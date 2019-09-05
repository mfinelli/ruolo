# frozen_string_literal: true

require 'rspec'

require 'ruolo/models/permission'

RSpec.describe Ruolo::Models::Permission do
  after(:all) do
    described_class.all.each(&:destroy)
  end

  it 'saves with valid input' do
    expect(build(:permission).save).to be_a(described_class)
  end
end
