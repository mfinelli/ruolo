# frozen_string_literal: true

require 'rspec'

require 'ruolo/models/user'

RSpec.describe Ruolo::Models::User do
  let(:klass) do
    Class.new(Sequel::Model(DB[:users])) do
      include Ruolo::Models::User
      plugin :timestamps, update_on_create: true
      many_to_many :roles, left_key: :user_id, join_table: :users_roles, class: 'Ruolo::Models::Role'
    end
  end

  before(:all) do
    Ruolo.sync!(File.expand_path(File.join(__FILE__, '..', '..', '..', 'fixtures','policies','user_spec.yml')))
  end

  after(:all) do
    Ruolo::Models::Role.all.each{ |r| r.destroy }
    Ruolo::Models::Permission.all.each{|p| p.destroy}
    Class.new(Sequel::Model(DB[:users])).all.each{|u| u.destroy}
  end

  describe '#permission?' do
    let(:user) do
      u = klass.create(email: Faker::Internet.unique.safe_email, password: 'password', first_name: 'fn', last_name: 'ln')
      u.add_role(Ruolo::Models::Role.where(name: 'ROLE_ONE').first)
      u
    end

    it 'returns true if it has the role' do
      expect(user.permission?('PERMISSION_ONE')).to eq(true)
    end

    it 'returns false if it doesn\'t have the role' do
      expect(user.permission?('PERMISSION_TWO')).to eq(false)
    end
  end
end
