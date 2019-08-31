# frozen_string_literal: true

require 'coveralls'
require 'factory_bot'
require 'rspec'
require 'sequel'

Coveralls.wear!

DB = if ENV['TRAVIS'].to_s.casecmp('true').zero?
       Sequel.connect('postgres://postgres@localhost/ruolo')
     else
       Sequel.connect('postgres://ruolo@localhost/ruolo')
     end

require 'ruolo'
require_relative 'mocks/user'

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.disable_monkey_patching!
  config.default_formatter = 'doc' if config.files_to_run.one?

  config.profile_examples = 10
  config.order = :random
  Kernel.srand config.seed

  config.before(:suite) do
    # Start with a fresh database
    tables = DB.tables.map(&:to_s).map { |t| %("#{t}") }.join(',')
    DB.run "DROP TABLE #{tables};" unless tables.empty?

    # Create the necessary tables
    Sequel.extension :migration
    Sequel::Migrator.run(DB, File.expand_path(File.join(File.dirname(__FILE__), 'fixtures', 'migrations')))

    Ruolo.configure do |c|
      c.user_class = RuoloMocks::User
      c.connection = DB
    end

    FactoryBot.find_definitions
  end
end
