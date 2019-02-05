class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

  def render_unprocessable_entity_response(exception)
    render json: exception.record.errors, status: :unprocessable_entity
  end

  def render_not_found_response(exception)
    render json: { error: exception.message }, status: :not_found
  end

  def render_unauthorized
    render json: { error: "unauthorized" }, status: :unauthorized
  end


  before_action :authenticate

  protected

  # Authenticate the user with token based authentication
  def authenticate
    authenticate_token || render_unauthorized
  end

  def authenticate_token
    @current_user = User.find_by(token: request.headers["API-TOKEN"].presence)
  end

  def render_unauthorized(realm = "Application")
    render json: 'Bad credentials', status: :unauthorized
  end
end
