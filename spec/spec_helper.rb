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

# Start with a fresh database
tables = DB.tables.map(&:to_s).map { |t| %("#{t}") }.join(',')
DB.run "DROP TABLE #{tables};" unless tables.empty?

# Create the necessary tables
Sequel.extension :migration
Sequel::Migrator.run(DB, File.expand_path(File.join(File.dirname(__FILE__), 'fixtures', 'migrations')))

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
    Ruolo.configure do |c|
      c.user_class = RuoloMocks::User
      c.connection = DB
    end

    FactoryBot.find_definitions
  end
end
