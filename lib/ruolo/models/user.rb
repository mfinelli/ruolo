# frozen_string_literal: true

module Ruolo
  module Models
    # A mixin to include in downstream user classes that adds useful helper
    # methods for dealing with roles and permissions.
    module User
      # Given the name of a permission determin whether the user's role
      # membership includes it.
      #
      # @param permission [String] the name of the permission
      # @return [Boolean] if the user has the permission or not
      def permission?(permission)
        roles.map { |role| role.permissions.map(&:name) }.flatten.uniq.include?(permission)
      end
    end
  end
end
