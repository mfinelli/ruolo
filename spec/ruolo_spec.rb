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

require 'ruolo'

RSpec.describe Ruolo do
  after(:all) do
    described_class.configure do |c|
      c.user_class = RuoloMocks::User
      c.connection = DB
    end
  end

  describe '.configuration' do
    context 'with no previous configuration' do
      before { described_class.reset }

      it 'returns a configuration object' do
        expect(described_class.configuration).to be_a(Ruolo::Configuration)
      end

      it 'has the default connection' do
        expect(described_class.configuration.connection).to be_nil
      end

      it 'has the default user class' do
        expect(described_class.configuration.user_class).to eql('User')
      end
    end

    context 'with previous configuration' do
      before do
        described_class.configure do |config|
          config.connection = 'test'
          config.user_class = 'NotUser'
        end
      end

      it 'returns a configuration object' do
        expect(described_class.configuration).to be_a(Ruolo::Configuration)
      end

      it 'returns the updated connection' do
        expect(described_class.configuration.connection).to eq('test')
      end

      it 'returns the updated user class' do
        expect(described_class.configuration.user_class).to eq('NotUser')
      end
    end
  end

  describe '.reset' do
    before do
      described_class.configure do |config|
        config.connection = 'not_nil'
        config.user_class = 'DifferentUser'
      end
    end

    context 'without calling reset' do
      it 'returns the configured connection' do
        expect(described_class.configuration.connection).to eq('not_nil')
      end

      it 'returns the configured user class' do
        expect(described_class.configuration.user_class).to eq('DifferentUser')
      end
    end

    context 'when calling reset' do
      before { described_class.reset }

      it 'returns the default connection' do
        expect(described_class.configuration.connection).to be_nil
      end

      it 'returns the default user class' do
        expect(described_class.configuration.user_class).to eq('User')
      end
    end
  end

  describe '.configure' do
    context 'without calling configure' do
      before { described_class.reset }

      it 'has the default connection' do
        expect(described_class.configuration.connection).to be_nil
      end

      it 'has the default user class' do
        expect(described_class.configuration.user_class).to eq('User')
      end
    end

    context 'when calling configure' do
      before do
        described_class.configure do |config|
          config.connection = 'postgres'
          config.user_class = 'GreatUser'
        end
      end

      it 'has the updated connection' do
        expect(described_class.configuration.connection).to eq('postgres')
      end

      it 'has the updates user class' do
        expect(described_class.configuration.user_class).to eq('GreatUser')
      end
    end
  end
end
