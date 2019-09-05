# frozen_string_literal: true

require 'factory_bot'
require 'faker'

require 'ruolo/models/permission'

FactoryBot.define do
  factory :permission, class: Ruolo::Models::Permission do
    name { Faker::Internet.slug.upcase }
  end
end
