require 'yaml'

require 'ruolo/configuration'
require 'ruolo/models'

module Ruolo
  class Sync
    def initialize(policy_file)
      @policy_document = YAML.safe_load(File.read(policy_file), symbolize_names: true)
    end

    def sync!
      Ruolo.configuration.connection.transaction do
        permissions_diff
        roles_diff
        roles_permissions_diff
      end
    end

    private

    def permissions_from_policy
      @policy_document[:roles].map{|role, permissions| permissions}.flatten.uniq
    end

    def roles_from_policy
      @policy_document[:roles].map{|role, permissions| role.to_s}
    end

    def permissions_diff
      permissions = Ruolo::Models::Permission.all
      policy = permissions_from_policy

      remove = permissions.select{|perm| !policy.include?(perm.name)}
      add = policy.reject{|pol| permissions.map{|perm| perm.name}.include?(pol)}

      remove.each do |permission|
        permission.destroy
      end

      add.each do |permission|
        Ruolo::Models::Permission.create(name: permission)
      end
    end

    def roles_diff
      roles = Ruolo::Models::Role.all
      policy = roles_from_policy

      remove = roles.select{|role| !policy.include?(role.name)}
      add = policy.reject{|pol| roles.map{|rol| rol.name}.include?(pol)}

      remove.each do |role|
        role.destroy
      end

      add.each do |role|
        Ruolo::Models::Role.create(name: role)
      end
    end

    def roles_permissions_diff
      roles = Ruolo::Models::Role.eager_graph(:permissions).all

      # at this point we should _only_ have the actual roles in the database
      roles.each do |role|
        policy = @policy_document[:roles][role.name.to_sym]

        remove = role.permissions.select{|perm| !policy.include?(perm.name)}
        add = policy.reject{|pol| role.permissions.map{|perm| perm.name}.include?(pol)}

        remove.each do |permission|
          role.remove_permission permission
        end

        add.each do |permission|
          role.add_permission Ruolo::Models::Permission.where(name: permission).first
        end
      end
    end
  end
end
