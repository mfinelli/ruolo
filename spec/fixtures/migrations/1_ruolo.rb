# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :users do
      primary_key :id, type: :Bignum

      column :email, String, null: false, size: 190, unique: true
      column :password, String, null: false, size: 60, fixed: true

      column :first_name, String, null: false
      column :last_name, String, null: false

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false

      constraint(:valid_email, email: /@/)
    end

    create_table :roles do
      primary_key :id, type: :Bignum

      column :name, String, null: false, size: 150, unique: true

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false

      constraint(:valid_name, name: /^[A-Z]([A-Z0-9]*[\-\._]?)*$/)
    end

    create_table :permissions do
      primary_key :id, type: :Bignum

      column :name, String, null: false, size: 150, unique: true

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false

      constraint(:valid_name, name: /^[A-Z]([A-Z0-9]*[\-\._]?)*$/)
    end

    create_table :users_roles do
      foreign_key :user_id, :users, null: false, type: :Bignum,
                                    on_update: :cascade, on_delete: :cascade
      foreign_key :role_id, :roles, null: false, type: :Bignum,
                                    on_update: :cascade, on_delete: :cascade
      primary_key %i[user_id role_id]
      index %i[role_id user_id]
    end

    create_table :roles_permissions do
      foreign_key :role_id, :roles, null: false, type: :Bignum,
                                    on_update: :cascade, on_delete: :cascade
      foreign_key :permission_id, :permissions, null: false, type: :Bignum,
                                                on_update: :cascade, on_delete: :cascade
      primary_key %i[role_id permission_id]
      index %i[permission_id role_id]
    end
  end
end
