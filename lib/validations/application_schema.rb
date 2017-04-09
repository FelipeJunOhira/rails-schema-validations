class ApplicationSchema < Dry::Validation::Schema

  configure do |config|
    # config.messages_file = '/my/app/config/locales/en.yml'
    # config.messages = :i18n
    config.type_specs = true
  end

end
