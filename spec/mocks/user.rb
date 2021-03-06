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

require 'sequel'

require 'ruolo/models/user'

module RuoloMocks
  class User < Sequel::Model
    include Ruolo::Models::User
    plugin :timestamps, update_on_create: true
    many_to_many :roles, join_table: :users_roles, class: 'Ruolo::Models::Role'
  end
end
