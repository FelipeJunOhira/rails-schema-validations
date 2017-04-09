class BaseSchema::Result

  attr_reader :result

  def initialize result
    @result = result
  end

  def valid?
    result.success?
  end

  def output
    result.output
  end

  def full_error_messages
    format_schema_full_error_messages_for result.messages
  end

  private
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
