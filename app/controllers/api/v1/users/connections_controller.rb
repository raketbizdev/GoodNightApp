class Api::V1::Users::ConnectionsController < Api::V1::BaseController
  before_action :authenticate_user!

  # POST /api/v1/users/connections
  # Follows another user
  def create
    user_to_follow = User.find(params[:following_id])
    current_user.following << user_to_follow

    if current_user.save
      render json: { status: 'success', message: 'User followed successfully' }, status: :ok
    else
      render json: { status: 'error', message: 'Unable to follow user' }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/users/connections/:id
  # Unfollows another user

  def destroy
    connection = current_user.connections_as_follower.find(params[:id])
    user = connection.following
    connection.destroy
    redirect_to user, notice: "You are no longer following #{user.name}."
  end
end
