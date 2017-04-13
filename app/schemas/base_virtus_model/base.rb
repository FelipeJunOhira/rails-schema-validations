class BaseVirtusModel::Base

  include Virtus.model
  include ActiveModel::AttributeAssignment
  include ActiveModel::Validations

  class << self

    def required field, type, options = {}, &block
      options.merge! presence: true

      define_field field, type, options, &block
    end

    def optional field, type, options = {}, &block
      options.delete :presence

      define_field field, type, options, &block
    end

    private
    def define_field field, type, options, &block
      define_attribute field, type, &block

      validates field, options if options.any?
    end

    def define_attribute field, type, &block
      if block_given?
        if type.instance_of?(Array)
          attribute field, ValidatableArray[build_nested_model(&block)]
        else
          attribute field, build_nested_model(&block)
        end
      else
        attribute field, type
      end
    end

    def build_nested_model &block
      Class.new(BaseVirtusModel::Base).tap do |field_klass|
        field_klass.instance_eval do
          def self.model_name
            ActiveModel::Name.new self, nil, "field"
          end
        end

        field_klass.instance_eval &block
      end
    end
  end

  def initialize data
    super(data)
  rescue NoMethodError
  rescue ActiveModel::UnknownAttributeError
    # Handle errors for extra attributes not declared on the ActiveModel::Model
  end

  def valid?
    to_h
      .keep_if { |key, value| value.respond_to?(:valid?) }
      .reduce(super) { |result, (key, value)| value.valid? && result }
  end

  def attributes
    super
      .keep_if { |key, value| errors[key].blank? }
      .transform_values { |value| get_value_attributes(value) }
  end

  private
  def get_value_attributes value
    if value.class.ancestors.include?(BaseVirtusModel::Base)
      value.attributes
    elsif value.class.ancestors.include?(Array)
      value.map { |element| get_value_attributes(element) }
    else
      value
    end
  end

end
