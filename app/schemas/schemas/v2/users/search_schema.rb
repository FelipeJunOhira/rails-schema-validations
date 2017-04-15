class Schemas::V2::Users::SearchSchema < BaseSchema

  root_node :users_search

  schema do

    required(:names, Types::Array).filled { each(:str?) }

    required(:telephones).each do
      schema do
        required(:type, Types::String).filled
        required(:number, Types::Int).filled
      end
    end

    validate(filled?: :telephones) { |field| field.present? }

  end

end
