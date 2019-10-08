# frozen_string_literal: true

# Copyright 2019 Mario Finelli
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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
    Ruolo.synchronize!(File.expand_path(File.join(__FILE__, '..', '..', '..', 'fixtures', 'policies', 'user_spec.yml')))
  end

  after(:all) do
    Ruolo::Models::Role.all.each(&:destroy)
    Ruolo::Models::Permission.all.each(&:destroy)
    Class.new(Sequel::Model(DB[:users])).all.each(&:destroy)
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

  describe '#role?' do
    let(:user) do
      u = klass.create(email: Faker::Internet.unique.safe_email, password: 'password', first_name: 'fn', last_name: 'ln')
      u.add_role(Ruolo::Models::Role.where(name: 'ROLE_ONE').first)
      u.add_role(Ruolo::Models::Role.where(name: 'ROLE_TWO').first)
      u
    end

    context 'with a string' do
      it 'returns true if the user has the role' do
        expect(user.role?('ROLE_ONE')).to eq(true)
      end

      it 'returns false if the user doesn\'t have the role' do
        expect(user.role?('ROLE_THREE')).to eq(false)
      end
    end

    context 'with an array' do
      it 'returns true if the user has any of the roles' do
        expect(user.role?(%w[ROLE_ONE])).to eq(true)
      end

      it 'returns false if the user doesn\'t have any of the roles' do
        expect(user.role?(%w[ROLE_THREE])).to eq(false)
      end

      it 'returns true if the user has all of the roles' do
        expect(user.role?(%w[ROLE_ONE ROLE_TWO])).to eq(true)
      end
    end
  end
end
