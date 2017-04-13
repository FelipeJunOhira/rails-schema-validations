class BaseVirtusModel::Root < BaseVirtusModel::Base

  class << self

    def root type, &block
      required :root, type, &block
    end

  end

  def initialize data
    super root: data
  end

  delegate :attributes, to: :root

end
