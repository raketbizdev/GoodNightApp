class Api::V1::Users::RegistrationsController < Api::V1::BaseController
  before_action :configure_permitted_parameters

  # POST /api/v1/users/signup
  # Endpoint for user registration
  def create
    user = User.new(user_params)
    if user.save
      render json: { success: true, message: I18n.t('api.v1.users.registrations.success_message', email: user.email) }, status: :created
    else
      render json: {success: false, errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  # Configure the parameters allowed for user registration
  def configure_permitted_parameters
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  # Extract the user parameters from the request
  def user_params
    configure_permitted_parameters
  end
end