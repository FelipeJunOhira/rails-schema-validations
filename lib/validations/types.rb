module Types
  include Dry::Types.module

  Name = Types::String.constructor do |str|
    str ? str.strip.chomp : str
  end

  Age = Types::Int.constructor do |int|
    int ? int.to_i : int
  end

  Array = Types::Array.constructor do |array|
    if array
      if array.instance_of?(ActiveSupport::HashWithIndifferentAccess) || array.instance_of?(::Hash)
        next_element = array.values.first

        if next_element.instance_of?(ActiveSupport::HashWithIndifferentAccess) || next_element.instance_of?(::Hash)
          [next_element]
        else
          Array(next_element)
        end
      else
        array
      end
    else
      array
    end
  end

end
