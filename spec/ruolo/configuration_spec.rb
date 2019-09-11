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
