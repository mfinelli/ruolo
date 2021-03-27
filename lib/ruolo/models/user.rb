# frozen_string_literal: true

# Copyright 2019-2020 Mario Finelli
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

module Ruolo
  module Models
    # A mixin to include in downstream user classes that adds useful helper
    # methods for dealing with roles and permissions.
    module User
      # Given the name of a permission determine whether the user's role
      # membership includes it.
      #
      # @param permission [String] the name of the permission
      # @return [Boolean] if the user has the permission or not
      def permission?(permission)
        roles.map do |role|
          role.permissions.map(&:name)
        end.flatten.uniq.include?(permission)
      end

      # Given a role name or array of role names determine if the user has
      # that/those roles.
      #
      # @param role [String|Array<String>] role(s) to check
      # @return [Boolean] if the user has the given role(s)
      def role?(role)
        !(roles.map(&:name) & Array(role)).empty?
      end

      # Given a set of all roles that the user should have add/remove roles as
      # necessary.
      #
      # @param wanted_roles [Array<String>] list of role names
      # @return [void]
      def set_roles(wanted_roles)
        current_roles = roles.map(&:name)

        remove = current_roles.reject { |r| wanted_roles.include?(r) }
        add = wanted_roles.reject { |r| current_roles.include?(r) }

        Ruolo.configuration.connection.transaction do
          remove.each do |role|
            remove_role(Ruolo::Models::Role.where(name: role).first)
          end

          add.each do |role|
            add_role(Ruolo::Models::Role.where(name: role).first)
          end
        end
      end
    end
  end
end
