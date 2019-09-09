# frozen_string_literal: true

require 'rspec'

require 'ruolo/models'
require 'ruolo/sync'

RSpec.describe Ruolo::Sync do
  describe '#initialize' do
    it 'returns a sync object' do
      expect(described_class.new(File.expand_path(File.join(__FILE__, '..', '..', 'fixtures', 'policies', 'empty.yml')))).to be_a(described_class)
    end
  end

  describe '#sync!' do
    before(:all) do
      old_role = Ruolo::Models::Role.create(name: 'OLD_ROLE')
      exist_role = Ruolo::Models::Role.create(name: 'EXISTING_ROLE')

      old_perm = Ruolo::Models::Permission.create(name: 'OLD_PERMISSION')
      exist_perm = Ruolo::Models::Permission.create(name: 'EXISTING_PERMISSION')

      [old_role, exist_role].each do |role|
        [old_perm, exist_perm].each do |permission|
          role.add_permission(permission)
        end
      end

      described_class.new(File.expand_path(File.join(__FILE__, '..', '..', 'fixtures', 'policies', 'sync_spec.yml'))).sync!
    end

    it 'adds missing roles' do
      expect(Ruolo::Models::Role.all.map(&:name)).to eq(['EXISTING_ROLE', 'NEW_ROLE'])
    end

    it 'removes old roles' do
      expect(Ruolo::Models::Role.all.map(&:name)).to eq(['EXISTING_ROLE', 'NEW_ROLE'])
    end

    it 'adds missing permissions' do
      expect(Ruolo::Models::Permission.all.map(&:name)).to eq(['EXISTING_PERMISSION', 'NEW_PERMISSION'])
    end

    it 'removes old permissions' do
      expect(Ruolo::Models::Permission.all.map(&:name)).to eq(['EXISTING_PERMISSION', 'NEW_PERMISSION'])
    end

    it 'associates new permissions to a role' do
      ['EXISTING_ROLE', 'NEW_ROLE'].each do |role|
        expect(Ruolo::Models::Role.where(name: role).first.permissions.map(&:name)).to eq(['EXISTING_PERMISSION', 'NEW_PERMISSION'])
      end
    end

    it 'removes old permissions from a role' do
      ['EXISTING_ROLE', 'NEW_ROLE'].each do |role|
        expect(Ruolo::Models::Role.where(name: role).first.permissions.map(&:name)).to eq(['EXISTING_PERMISSION', 'NEW_PERMISSION'])
      end
    end
  end
end
