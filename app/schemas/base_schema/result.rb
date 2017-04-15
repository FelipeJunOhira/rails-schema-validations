class BaseSchema::Result

  attr_reader :result, :root_node

  def initialize result, options = {}
    @result = result

    @root_node = options[:root_node]
  end

  def valid?
    result.success?
  end

  def output
    if root_node.present?
      {
        root_node => result.output
      }
    else
      result.output
    end
  end

  def full_error_messages
    format_schema_full_error_messages_for result.messages(locale: I18n.locale)
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
