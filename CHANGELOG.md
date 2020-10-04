# Ruolo Change Log

This file keeps track of changes between releases for the ruolo project
which adheres to [semantic versioning](https://semver.org).

## unreleased

Correct sample database constraints to remove a useless regular expression
escape.

## v0.4.0 2020-03-27

Add `set_roles` method to the user mixin to synchronize desired roles for an
individual user.

## v0.3.0 2019-10-08

Add a `role?` method to the user mixin to check for given roles instead of
permissions.

## v0.2.0 2019-09-11

Initial cleanup of original code: add tests and documentation.

* Drop support for ruby 2.4.x.

## v0.1.0 2019-08-25

Initial release.
