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

require 'ruolo/configuration'
require 'ruolo/version'

# Define a policy file in yaml and ruolo will keep your roles and permissions
# in sync with your database.
module Ruolo
  class << self
    attr_writer :configuration
  end

  # Get the current configuration.
  #
  # @return [Ruolo::Configuration] the configuration class, configured
  def self.configuration
    @configuration ||= Ruolo::Configuration.new
  end

  # Reset the current configuration to the defaults.
  #
  # @return [void]
  def self.reset
    @configuration = Ruolo::Configuration.new
  end

  # Gives a block with which to configure.
  #
  # @yieldparam comfig [Ruolo::Configuration] configuration object
  # @yieldreturn [void]
  def self.configure
    yield(configuration)
  end

  # Given a policy file synchronize the roles and permissions in the database.
  #
  # @param policy_file [String] path to a yaml policy file
  # @return [void]
  def self.synchronize!(policy_file)
    Ruolo::Sync.new(policy_file).sync!
  end
end

require 'ruolo/models'
require 'ruolo/sync'
