# frozen_string_literal: true

require 'sequel'

require 'ruolo/models/user'

module RuoloMocks
  class User < Sequel::Model
    include Ruolo::Models::User
    plugin :timestamps, update_on_create: true
    many_to_many :roles, join_table: :users_roles, class: 'Ruolo::Models::Role'
  end
end
