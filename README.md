# Ruolo

[![Build Status](https://travis-ci.org/mfinelli/ruolo.svg?branch=master)](https://travis-ci.org/mfinelli/ruolo)

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
```

### User Class

You'll need to set your `User` class to use the correct association class, and
configure `ruolo` to use the correct user class (you can also include the
ruolo user module for the `permission?` mixin helper):

```ruby
Ruolo.configure do |c|
  c.user_class = 'YourApp::User'
end

module YourApp
  class User < Sequel::Model
    include Ruolo::Models::User
    many_to_many :roles, join_table: :users_roles, class: 'Ruolo::Models::Role'
  end
end
```

### Policy

To create your static permissions and roles create a yaml file with the
following format, the permission list is derived from the permissions that are
defined for the roles:

```yaml
---
roles:
  POST_ADMIN:
    - CREATE_POST
    - DELETE_POST
  POST_CREATOR:
    - CREATE_POST
```

### Sync

After adding the migrations, configuring ruolo and your custom user class, and
defining your RBAC policy, run the sync during your application startup:

```ruby
require 'sequel'
require 'ruolo'

DB = Sequel.connect('...')

Ruolo.configure do |config|
  config.connection = DB
end

Ruolo.sync!('./path/to/policy.yml')
```

## Gem Development

To hack on the gem you'll need PostgreSQL installed and running, then create a
user and database:

```shell
$ createuser ruolo
$ createdb ruolo
```

Then you can ensure everything was created correctly:

```shell
$ psql -U ruolo
```

You can use the `bin/console` command which will load in dependencies, and
migrate the database on load. It also provides the helper methods `reset_db!`
and `migrate_db!` if you want to run those operations manually after the code
has loaded.

```shell
$ bundle exec bin/console
```

## License

```
Copyright 2019 Mario Finelli

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
