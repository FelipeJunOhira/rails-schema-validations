class BaseVirtusModel

  include Virtus.model
  include ActiveModel::Model

  class << self

    def root type, &block
      required :root, type, &block
    end

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
      Class.new(BaseVirtusModel).tap do |field_klass|
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
    super root: data
  rescue ActiveModel::UnknownAttributeError
    # Handle errors for extra attributes not declared on the ActiveModel::Model
  end

  def valid?
    attributes_that_respont_to(:valid?).reduce(super) do |result, attributes|
      self[attributes].valid? && result
    end
  end

  def attributes_that_respont_to method
    attributes.keys.select { |attribute| self[attribute].respond_to? method }
  end

end
