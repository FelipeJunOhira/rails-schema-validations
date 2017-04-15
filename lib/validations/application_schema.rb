class ApplicationSchema < Dry::Validation::Schema

  configure do |config|
    config.messages_file = 'config/locales/schemas/errors.pt-BR.yml'

    config.messages = :i18n
    config.type_specs = true
  end

end
