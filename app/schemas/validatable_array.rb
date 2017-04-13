class ValidatableArray < Array

  def valid?
    reduce(true) do |result, element|
      element.valid? && result if element.respond_to?(:valid?)
    end
  end

end
