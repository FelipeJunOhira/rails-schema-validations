class VirtusModel::V2::Users::SearchSchema < BaseVirtusModel::Root

  root Hash do

    required :names, Array[String]

    # required(:names, Types::Array).filled do
    #   each(:str?)
    # end
    #
    # required(:telephones, Types::Array).each do
    #   schema do
    #     required(:type).filled
    #     required(:number, Types::Int).filled
    #   end
    # end

  end
end
