class Api::BaseController < ApplicationController
  skip_before_action :verify_authenticity_token
  respond_to :json

  protected

  def authenticate_user!
    token = request.headers["Authorization"]&.split(" ")&.last
    payload = JwtService.decode(token)

    unless payload
      render json: { error: "Unauthorized" }, status: :unauthorized
      return false
    end

    @current_user = User.find_by(id: payload["user_id"])

    unless @current_user
      render json: { error: "Unauthorized" }, status: :unauthorized
      return false
    end

    true
  end

  def current_user
    @current_user
  end

  def render_success(data, status: :ok)
    render json: { success: true, data: data }, status: status
  end

  def render_error(message, status: :unprocessable_entity)
    render json: { success: false, error: message }, status: status
  end
end
