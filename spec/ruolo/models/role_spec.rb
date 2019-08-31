# frozen_string_literal: true

require 'rspec'

require 'ruolo/models/role'

RSpec.describe Ruolo::Models::Role do
  it 'saves with valid input' do
    expect(build(:role).save).to be_a(described_class)
  end
end
