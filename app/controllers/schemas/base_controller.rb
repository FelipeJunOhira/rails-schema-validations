class Schemas::BaseController < ApplicationController

  before_action do
    binding.pry
  end

  def schema_class
    schema_class_name.constantize
  end

  def schema_class_name
    "#{params[:controller]}/#{params[:action]}_schema".camelize
  end

end
