# Ruolo

A library for generating and keeping your static role-based access-control
policies in sync with your database using the
[sequel](https://github.com/jeremyevans/sequel) gem.

You're an application developer and know all of the permissions and roles that
you want to create - you want to create them in code and have them persist to
the database (and stay in sync should you add/change/remove something). This
is what `ruolo` can help with: define your RBAC policies using a DSL and run
the sync on application start up. You're responsible for both the authentication
and authorization of users after that, `ruolo` is completely unopinionated.

## Usage

### Migrations

You'll need to run the following database migration to setup your schema, fill
in the `users` table with your own details:

```ruby
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
      column :description, String

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false

      constraint(:valid_name, name: /^[A-Z]([A-Z0-9]*[\-\._]?)*$/)
    end

    create_table :permissions do
      primary_key :id, type: :Bignum

      column :name, String, null: false, size: 150, unique: true
      column :description, String

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false

      constraint(:valid_name, name: /^[A-Z]([A-Z0-9]*[\-\._]?)*$/)
    end

    create_table :users_roles do
      foreign_key :user_id, :users, null: false, type: :Bignum,
        on_update: :cascade, on_delete: :cascade
      foreign_key :role_id, :roles, null: false, type: :Bignum,
        on_update: :cascade, on_delete: :cascade
      primary_key [:user_id, :role_id]
      index [:role_id, :user_id]
    end

    create_table :roles_permissions do
      foreign_key :role_id, :roles, null: false, type: :Bignum,
        on_update: :cascade, on_delete: :cascade
      foreign_key :permission_id, :permissions, null: false, type: :Bignum,
        on_update: :cascade, on_delete: :cascade
      primary_key [:role_id, :permission_id]
      index [:permission_id, :role_id]
    end
  end
end
```
