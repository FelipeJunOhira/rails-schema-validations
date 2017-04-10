class Schemas::V2::UsersController < Schemas::V2::BaseController

  def search
    render json: params.to_unsafe_hash, status: :ok
  end

  def create
    render json: params.to_unsafe_hash, status: :ok
  end

  def show
    render json: params.to_unsafe_hash, status: :ok
  end

end
