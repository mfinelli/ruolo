# frozen_string_literal: true

require 'ruolo/configuration'
require 'ruolo/version'

module Ruolo
  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Ruolo::Configuration.new
  end

  def self.reset
    @configuration = Ruolo::Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  def self.sync!(policy_file)
    Ruolo::Sync.new(policy_file).sync!
  end
end

require 'ruolo/models'
require 'ruolo/sync'
