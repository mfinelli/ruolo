# frozen_string_literal: true

module Ruolo
  # A class that defines all the configuration overrides.
  class Configuration
    attr_accessor :connection, :user_class

    # Create a new configuration object.
    #
    # @return [Ruolo::Configuration] the new configuration
    def initialize
      @connection = nil
      @user_class = 'User'
    end
  end
end
