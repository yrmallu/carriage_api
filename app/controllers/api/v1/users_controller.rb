module Api::V1
  class UsersController < ApiController
    before_action :authenticate, except: [:sign_up, :login]

    def index
      start = params[:start] || 0
      limit = params[:limit] || 10
      render json: User.select(:username, :email, :role)
                        .offset(start)
                        .limit(limit), status: :ok
    end


    def login
      user = User.find_by_username params[:username]
      if user.authenticate_user params[:password]
        render json: { token: user.token }, status: :ok
      else
        render json: { error: "invalid username or password" }, status: :unauthorized
      end
    end

    def sign_up
      user = User.new(user_params)
      if user.save
        render status: :created
      else
        render json: { error: user.errors }, status: :unprocessable_entity
      end
    end

    private
    def user_params
      params.require(:user).permit(:email ,:password ,:username ,:token)
    end

  end
end