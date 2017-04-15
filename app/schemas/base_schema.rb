class BaseSchema

  class << self
    attr_reader :schema_root_node

    def for_xml input
      schema_root_node ? new(input[schema_root_node]) : new(input)
    end

    def for_json input
      new(input)
    end

    def root_node schema_root_node
      @schema_root_node = schema_root_node
      define_method(:root_node) { schema_root_node }
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
    preprocess_params

    BaseSchema::Result.new(schema.call(input), root_node: root_node)
  end

  private
  def preprocess_params
    # Fix differences between xml and json array nodes
    fix_array_nodes schema.type_map
  end

  def fix_array_nodes hash, paths = []
    hash.each_pair do |field, dry_type|
      current_field_path = (paths + [field])

      case dry_type.name
      when "Array"
        node_to_fix = node_by_path(paths) || {}
        possible_value_to_fix = node_by_path(current_field_path) || {}

        if behaves_like_hash?(node_to_fix)
          node_to_fix[field] = fix_array_value(possible_value_to_fix)

          begin
            node_to_fix[field].each_with_index do |element, index|
              fix_array_nodes dry_type.type.type.member.member_types, (current_field_path + [index])
            end
          rescue NoMethodError
            # Ignore errors in case of arrays as leafs
          end
        end

      when "Hash"
        fix_array_nodes dry_type.member_types, current_field_path
      end
    end
  end

  def behaves_like_hash? object
    object.instance_of?(ActiveSupport::HashWithIndifferentAccess) || object.instance_of?(Hash)
  end

  def node_by_path path = []
    path.reduce(input) { |hash, key| hash[key] }
  rescue
    nil
  end

  def fix_array_value node
    if behaves_like_hash?(node)
      correct_array_value = node.values.first

      enforce_array_type(correct_array_value)
    else
      Array(node)
    end
  end

  def enforce_array_type object
    if behaves_like_hash?(object)
      # Fix to hash-like object, as Array({ a: 2 }) => [[:a, 2]]
      [object]
    else
      # Convert manually as value can be nil
      Array(object)
    end
  end

end
