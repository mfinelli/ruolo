# frozen_string_literal: true

module Ruolo
  class Configuration
    attr_accessor :connection, :user_class

    def initialize
      @connection = nil
      @user_class = 'User'
    end
  end
end
