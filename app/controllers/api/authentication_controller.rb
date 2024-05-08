class Api::AuthenticationController < Api::ApplicationController
  skip_before_action :authenticate_user

  before_action :set_user, only: :create

  def create
    if @user&.authenticate(auth_params[:password])
      token = jwt_token
      render json: { token: token }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  private

  def set_user
    @user = User.find_by(email: auth_params[:email])
  end

  def auth_params
    params.require(:authentication).permit(:email, :password)
  end

  def jwt_token
    JsonWebToken.user_token(@user)
  end
end
