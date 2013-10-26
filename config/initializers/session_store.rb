# Be sure to restart your server when you modify this file.

#Cloud32::Application.config.session_store :cookie_store, key: '_cloud3.2_session'

require 'action_dispatch/middleware/session/dalli_store'
Rails.application.config.session_store :dalli_store, :memcache_server => ['sessions.0e6avx.cfg.use1.cache.amazonaws.com:11211'], :namespace => 'sessions', :key => '_cloud3.2_session', :expire_after => 1.day

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# Cloud32::Application.config.session_store :active_record_store
