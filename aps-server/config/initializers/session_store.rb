# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_aps-server_session',
  :secret      => '36bb344e1cd2c8faf4964d86395153900f06ec29bfe7c83b4c0f931234c5732eac357e8a7874270bcd3b0a9052248c537df65b2ae156900f66e892b30a3149c5'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
