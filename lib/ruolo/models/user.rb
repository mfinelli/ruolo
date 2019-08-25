module Ruolo
  module Models
    module User
      def permission?(permission)
        roles.map{|role| role.permissions.map{|permission| permission.name}}.flatten.uniq.include?(permission)
      end
    end
  end
end
