require 'factory_bot'
require 'faker'

require 'ruolo/models/role'

FactoryBot.define do
  factory :role, class: Ruolo::Models::Role do
    name { Faker::Internet.slug.upcase }
  end
end
