class BaseVirtusModel

  include Virtus.model
  include ActiveModel::Model

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
      if block_given?
        attribute field, build_nested_model(&block)
      else
        attribute field, type
      end

      validates field, options if options.any?
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

  def initialize *args, &block
    super *args, &block
  rescue ActiveModel::UnknownAttributeError
    # Handle errors for extra attributes not declared on the ActiveModel::Model
  rescue ArgumentError
    # Handle errors when receiving something other than a Hash-like object
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
