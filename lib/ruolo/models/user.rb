# frozen_string_literal: true

module Ruolo
  module Models
    module User
      def permission?(permission)
        roles.map { |role| role.permissions.map(&:name) }.flatten.uniq.include?(permission)
      end
    end
  end
end
