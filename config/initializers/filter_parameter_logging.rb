# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += [:password, :"stripe-secret-key", :"stripe-publishable-key", :"api-key", :encrypted_stripe_publishable_key, :encrypted_stripe_secret_key, :email]
