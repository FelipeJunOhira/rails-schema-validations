module Types
  include Dry::Types.module

  Int = Types::Int.constructor do |int|
    int.to_i
  end

  String = Types::String.constructor do |string|
    string.to_s
  end

  DateTime = Types::DateTime.constructor do |date_time|
    date_time.to_datetime
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
