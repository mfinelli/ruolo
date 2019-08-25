# frozen_string_literal: true

require 'sequel'

module Ruolo
  module Models
    class Permission < Sequel::Model
      plugin :timestamps, update_on_create: true
      many_to_many :roles, join_table: :roles_permissions
    end
  end
end
