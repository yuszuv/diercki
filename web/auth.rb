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

    # The password hash travels base64-encoded, and this is not decoration.
    #
    # A bcrypt hash is "$2a$12$…" — three fields separated by dollar signs. Docker
    # Compose interpolates ${…} in every value it reads, including the ones in a
    # .env file, and no quoting or $$-doubling stops it there. Measured: the hash
    # "$2a$12$KDvI6RuYis…/qxuoa" arrives inside the container as "a2/qxuoa".
    #
    # That failure is silent. The application would start, and the correct
    # password would simply be rejected. Base64 has no dollar signs, so nothing
    # on the way in can chew on it — and the check below turns a wrong value into
    # a refusal to start instead of a login that never works.
    # %r{} rather than //: the character class holds a slash, which would end a
    # slash-delimited literal right there.
    BCRYPT = %r{\A\$2[aby]\$\d\d\$[./A-Za-z0-9]{53}\z}

    def self.password_hash
      raw = env!('ATLAS_PASSWORT_HASH')
      # unpack1('m0') is strict base64 and comes with core Ruby — base64 stopped
      # being a default gem in 3.4, and this needs no gem at all.
      hash = begin
        raw.unpack1('m0')
      rescue ArgumentError
        abort_hash('ist kein gültiges Base64')
      end

      abort_hash('ergibt dekodiert keinen bcrypt-Hash') unless hash.match?(BCRYPT)
      hash
    end

    def self.abort_hash(what)
      abort <<~TEXT
        ATLAS_PASSWORT_HASH #{what}.

        Erwartet wird der bcrypt-Hash, base64-kodiert. Erzeugen mit:

          ruby -rbcrypt -e 'print [BCrypt::Password.create("DEIN PASSWORT")].pack("m0")'

        Base64, weil docker compose in jedem Wert ${…} auflöst — auch in der
        .env — und ein bcrypt-Hash aus $-Feldern besteht. Roh übergeben käme er
        verstümmelt an, und das Passwort würde stillschweigend nicht mehr passen.
      TEXT
    end

    def self.database
      db = Sequel.sqlite
      db.create_table(:accounts) do
        primary_key :id
        String :email, null: false, unique: true
        String :password_hash, null: false
      end
      db[:accounts].insert(email: env!('ATLAS_KONTO'), password_hash: password_hash)
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
