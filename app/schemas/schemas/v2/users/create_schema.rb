module Schemas::V2::Users
  CreateSchema = Dry::Validation.Schema do
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
end
