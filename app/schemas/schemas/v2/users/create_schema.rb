class Schemas::V2::Users::CreateSchema < BaseSchema

  xml_root_node :user

  schema do

    required(:name, Types::Type).filled

    required(:age, Types::Int).maybe(:int?)

    required(:address).schema do

      required(:street, Types::String).filled
      required(:city, Types::String).filled
      required(:zipcode, Types::String).filled

      required(:telephones, Types::Array).each do
        schema do
          required(:type, Types::Type).filled
          required(:number, Types::Int).filled
        end
      end

    end

  end

  # Examples
  # Valid
  # {
  # 	"name": "Bob",
  # 	"age": 123,
  # 	"address": {
  # 		"street": "hey",
  # 		"city": false,
  # 		"zipcode": true,
  # 		"telephones": [
  # 			{
  # 				"type": true,
  # 				"number": "(11) 99999-9999"
  # 			}
  # 		]
  # 	}
  # }
  #
  # Invalid
  # {
  # 	"age": 123,
  # 	"address": {
  # 		"street": "hey",
  # 		"telephones": [
  # 			{
  # 				"type": true
  # 			}
  # 		]
  # 	}
  # }
end
