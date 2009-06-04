# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_beatles_session',
  :secret      => '6628f79a70375c8d543b6d32994f4898095fec6ec196f9cf165f15581e53d4164f63c26161f7599f44905436cbe0c54fca6a2ebd80bfcb4527579bb3ed441c5f'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
