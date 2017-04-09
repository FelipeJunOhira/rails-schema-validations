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
      schema_class.for_xml(params.to_unsafe_hash)
    else
      schema_class.for_json(params.to_unsafe_hash)
    end
  end

  def schema_class
    schema_class_name.constantize
  end

  def schema_class_name
    "#{params[:controller]}/#{params[:action]}_schema".camelize
  end


end
