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

      remove = []

      policy = permissions_from_policy

      permissions.each do |permission|
        remove << permission unless policy.include? permission.name
      end

      add = policy.reject{|pol| permissions.map{|perm| perm.name}.include?(pol)}

      remove.each do |permission|
        permission.destroy
      end

      add.each do |permission|
        Ruolo::Models::Permission.create(name: permission)
      end
    end
  end
end
