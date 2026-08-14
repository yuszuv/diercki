# frozen_string_literal: true

require_relative 'boot'
require 'roda'
require 'sequel'
require 'bcrypt'

module Atlas
  # The login, as a Roda middleware in front of everything.
  #
  # Why a middleware and not a branch of the routing tree: two of the guarded
  # paths are static files — a deck and a photograph — and those are served by
  # Middleware::Files, which sits in front of the application. A branch inside
  # Atlas::App would never see them. A middleware sees every request, including
  # whatever route someone adds next year.
  #
  # This app owns the two addresses /anmelden and /abmelden and puts the rodauth
  # object into the Rack env. It does not decide WHAT is guarded — that is
  # Middleware::Guard reading web/geschuetzt.csv, because the list is an
  # editorial decision and this file is a mechanism.
  #
  # --- Why there is no database file ------------------------------------------
  #
  # Rodauth requires Sequel and a database; there is no file-free mode. But with
  # only :login and :logout enabled it never writes — no account creation, no
  # password reset, no remember tokens, no lockout counters. Measured, not
  # assumed: a full login/logout cycle issues zero INSERT, UPDATE or DELETE.
  #
  # So the account lives in an in-memory SQLite, seeded at boot from the
  # environment. The application stays stateless, the image stays immutable, the
  # dev preview's bind mount stays read-only, and there is nothing to back up.
  # Several Puma workers each get their own copy — identical, and never written
  # to. The session lives in a signed cookie, so nothing needs sharing.
  module Auth
    # Required, never defaulted. A fallback secret is worse than none, because
    # nothing looks broken while it is in place.
    def self.env!(name)
      ENV.fetch(name) do
        abort "#{name} fehlt. Ohne diese Angabe startet der Atlas nicht — " \
              'siehe README, Abschnitt „Getting it running".'
      end
    end

    def self.database
      db = Sequel.sqlite
      db.create_table(:accounts) do
        primary_key :id
        String :email, null: false, unique: true
        String :password_hash, null: false
      end
      db[:accounts].insert(email: env!('ATLAS_KONTO'),
                           password_hash: env!('ATLAS_PASSWORT_HASH'))
      db
    end
  end

  class AuthApp < Roda
    include Views

    DB = Auth.database

    plugin :middleware
    plugin :sessions,
           secret: Auth.env!('ATLAS_SESSION_SECRET'),
           key: 'atlas.sitzung'
    plugin :render,
           views: File.join(__dir__, 'templates'),
           engine: 'html.erb',
           layout: 'layout',
           escape: true

    plugin :rodauth do
      # Exactly two features. Everything Rodauth can otherwise do — registration,
      # password reset, remember me, lockout — would need a table that gets
      # written to, and none of it applies to a single account whose password
      # lives in the environment.
      enable :login, :logout

      db DB
      accounts_table :accounts
      login_column :email
      account_password_hash_column :password_hash
      account_status_column nil # no account_statuses table, no verification
      use_database_authentication_functions? false

      # German addresses, like the rest of the site.
      login_route 'anmelden'
      logout_route 'abmelden'

      # Do not tell an attacker which half was wrong.
      login_error_flash 'Konto oder Passwort stimmt nicht.'
      no_matching_login_message 'Konto oder Passwort stimmt nicht.'
      invalid_password_message 'Konto oder Passwort stimmt nicht.'

      login_button 'Anmelden'
      logout_button 'Abmelden'
      logout_redirect '/'
    end

    route do |r|
      env['rodauth'] = rodauth
      r.rodauth
    end
  end
end
