class Api::V1::Users::SessionsController < Devise::SessionsController
  respond_to :json
  before_action :authenticate_user!, except: [:create]
  include ActionController::MimeResponds

  # POST /api/v1/users/sign_in
  # Authenticates a user and returns a JWT token if successful.
  # Params:
  # - user[email]: string (required)
  # - user[password]: string (required)
  def create
    user = User.find_by(email: params[:_jsonapi][:user][:email])

    if user && user.valid_password?(params[:_jsonapi][:user][:password])
      sign_in(:user, user)

      token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil)
      response.set_header('Authorization', "Bearer #{token}")
      render json: { message: I18n.t('api.v1.users.sessions.logged_in'), user: user, token: token }
    else
      render json: { error: I18n.t('api.v1.users.sessions.invalid_email_password') }, status: :unauthorized
    end
  end 

  # DELETE /api/v1/users/sign_out
  # Logs out the current user and revokes the JWT token.
  def destroy
    current_user.update(jti: SecureRandom.uuid)
    render json: { message: I18n.t('api.v1.users.sessions.logged_out') }
  end

  def respond_to(*args)
    if request.format.json?
      super
    else
      head :not_acceptable
    end
  end
end