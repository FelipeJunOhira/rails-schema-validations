class BaseSchema

  class << self
    attr_reader :root_node

    def for_xml input
      root_node ? new(input[root_node]) : new(input)
    end

    def for_json input
      new(input)
    end

    def xml_root_node root_node
      @root_node = root_node
    end

    def schema &block
      define_method(:schema) do
        @schema ||= Dry::Validation.Form(ApplicationSchema) do
          self.instance_exec(&block)
        end
      end
    end
  end

  attr_reader :input

  def initialize input
    @input = input
  end

  def call
    BaseSchema::Result.new(schema.call(input))
  end

end
