# frozen_string_literal: true

require 'sequel'

require 'ruolo/configuration'

module Ruolo
  module Models
    class Role < Sequel::Model
      plugin :timestamps, update_on_create: true
      many_to_many :permissions, join_table: :roles_permissions
      many_to_many :users, join_table: :users_roles, class: Ruolo.configuration.user_class
    end
  end
end
