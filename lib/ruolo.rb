require 'ruolo/configuration'
require 'ruolo/models'
require "ruolo/version"

module Ruolo
  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
