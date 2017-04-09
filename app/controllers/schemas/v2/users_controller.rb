class Schemas::V2::UsersController < Schemas::V2::BaseController

  def search
    render json: params.to_unsafe_hash, status: :ok
  end

  def create
    head :ok
  end

  def show
    head :ok
  end

end
