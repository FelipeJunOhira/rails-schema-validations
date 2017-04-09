class Schemas::V2::Users::CreateSchema < BaseSchema

  xml_root_node :user

  schema do

    required(:name).filled

    required(:age).maybe(:int?)

    required(:address).schema do

      required(:street).filled
      required(:city).filled
      required(:zipcode).filled

      required(:telephones).each do
        schema do
          required(:type).filled
          required(:number).filled
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
