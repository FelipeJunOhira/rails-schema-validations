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

end
