# frozen_string_literal: true

# Copyright 2019 Mario Finelli
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
