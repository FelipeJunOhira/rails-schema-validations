class VirtusModel::V2::Users::CreateSchema < BaseVirtusModel::Root

  # class Size < BaseVirtusModel
  #
  #   required :value, String
  # end

  root Hash do

    required :name, String

    optional :age, Integer, numericality: { greater_than: 18, less_than: 90 }

    # required :size, Hash do
    #   required :value, Integer, numericality: { only_integer: true }
    # end

    # optional :telephones, Array[String], length: { minimum: 2 }

    optional :friends, Array[Hash] do
      required :name, String
    end

  end


  # Examples
  # Valid
  # {
  # 	"name": "Bob",
  # 	"age": 123
  # }
  # {
  # 	"name": "Bob"
  # }
  #
  # Invalid
  # {
  # 	"age": 123
  # }
end
