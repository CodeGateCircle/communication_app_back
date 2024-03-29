require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CommunicationAppBack
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # すべてのhostを許可
    config.hosts.clear

    # Configuration for the application, engines, and railties goes here.
    config.active_storage.variable_content_types += ['image/jpg']
    config.active_storage.silence_invalid_content_types_warning = true

    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    # for omniauth
    config.session_store :cookie_store, key: '_interslice_session'
    config.middleware.use ActionDispatch::Cookies # Required for all session management
    config.middleware.use ActionDispatch::Session::CookieStore, config.session_options
    # ↑ここまで↑
    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.

    config.action_cable.mount_path = "/cable"

    config.action_cable.allowed_request_origins = [%r{http://*}, %r{https://*}, nil]

    config.api_only = true
  end
end
