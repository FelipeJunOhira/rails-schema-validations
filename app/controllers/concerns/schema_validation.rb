module SchemaValidation
  extend ActiveSupport::Concern

  included { before_action :validate_schema }

  def validate_schema
    result = schema.call

    if result.valid?
      params.merge!(result.output)
    else
      render json: result.full_error_messages, status: :unprocessable_entity
    end
  end

  private
  def schema
    if request.content_type == 'application/xml'
      schema_class.for_xml(formatted_parameters)
    else
      schema_class.for_json(formatted_parameters)
    end
  end

  def formatted_parameters
    params
      .to_unsafe_hash
      .deep_transform_keys { |key| key.to_s.underscore }
      .deep_symbolize_keys
  end

  def schema_class
    schema_class_name.constantize
  end

  def schema_class_name
    "#{params[:controller]}/#{params[:action]}_schema".camelize
  end


end
