# frozen_string_literal: true

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
