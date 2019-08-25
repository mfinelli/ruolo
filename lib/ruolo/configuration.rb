# frozen_string_literal: true

module Ruolo
  class Configuration
    attr_accessor :user_class

    def initialize
      @user_class = 'User'
    end
  end
end
