class Schemas::V2::Users::SearchSchema < BaseSchema

  xml_root_node :users_search

  schema do

    required(:names, Types::Array) do
      filled? & each(:str?)
    end

    required(:age, Types::Age).filled

    required(:telephones, Types::Array) do
      filled? & each do
        schema do
          required(:type).filled
          required(:number).filled
        end
      end
    end

  end

end
