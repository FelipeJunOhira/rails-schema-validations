class Schemas::BaseController < ApplicationController

  before_action :validate_parameters_schema

  def validate_parameters_schema
    errors = schema_class.call(params.to_unsafe_hash).messages

    if errors.any?
      render json: format_schema_full_error_messages_for(errors), status: :unprocessable_entity
      # render xml: format_schema_full_error_messages_for(errors).to_xml(root: 'errors', skip_types: true), status: :unprocessable_entity
    end
  end

  private
  def schema_class
    schema_class_name.constantize
  end

  def schema_class_name
    "#{params[:controller]}/#{params[:action]}_schema".camelize
  end

  def format_schema_full_error_messages_for errors
    [].tap do |accumulator|
      errors.each_pair do |field, errors|
        if errors.instance_of? Hash
          format_schema_full_error_messages_for(errors).each do |error_message|
            accumulator << "[#{field}]#{error_message}"
          end
        else
          errors.each do |error|
            accumulator << "[#{field}] #{error}"
          end
        end
      end
    end
  end

end
