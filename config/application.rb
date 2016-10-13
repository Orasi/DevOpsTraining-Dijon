require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MustardFront
  class Application < Rails::Application
    config.autoload_paths += %W(#{config.root}/app)
    config.autoload_paths += %W(#{config.root}/lib)
    config.mustard_api = 'http://10.238.242.61:8081'

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
