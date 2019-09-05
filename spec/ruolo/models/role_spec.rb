# frozen_string_literal: true

require 'rspec'

require 'ruolo/models/role'

RSpec.describe Ruolo::Models::Role do
  after(:all) do
    Ruolo::Models::Role.all.each{ |r| r.destroy }
  end

  it 'saves with valid input' do
    expect(build(:role).save).to be_a(described_class)
  end
end
