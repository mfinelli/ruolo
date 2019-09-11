# frozen_string_literal: true

require 'ruolo/configuration'
require 'ruolo/version'

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
