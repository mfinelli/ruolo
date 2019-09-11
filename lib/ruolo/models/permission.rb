# frozen_string_literal: true

require 'sequel'

module Ruolo
  module Models
    # Models an individual permission that can be associated to one or more
    # roles.
    class Permission < Sequel::Model
      plugin :timestamps, update_on_create: true
      many_to_many :roles, join_table: :roles_permissions
    end
  end
end
