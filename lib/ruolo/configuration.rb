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

module Ruolo
  # A class that defines all the configuration overrides.
  class Configuration
    # Sequel to connection to use.
    attr_accessor :connection
    # User class for association with ruolo models.
    attr_accessor :user_class

    # Create a new configuration object.
    #
    # @return [Ruolo::Configuration] the new configuration
    def initialize
      @connection = nil
      @user_class = 'User'
    end
  end
end
