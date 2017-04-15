require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Schemas
  class Application < Rails::Application

    config.eager_load_paths << 'lib/validations'

    config.i18n.default_locale = :'pt-BR'

  end
end
