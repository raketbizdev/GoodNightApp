class Api::V1::UsersController < Api::V1::BaseController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :follow, :unfollow, :clock_in, :clock_out, :update]
  before_action :load_user_with_profile, only: [:update]

  # GET /api/v1/users/
  # list of all users
  def index
    users = User.summary_list
  
    user_count = User.count
    follower_count = current_user.follower_count
    following_count = current_user.following_count
  
    render json: {
      users: users,
      user_count: user_count,
      followers_count: follower_count,
      followings_count: following_count
    }, status: :ok
  end

  # GET /api/v1/users/:id
  # Retrieves detailed information about a specific user
  def show
    sleep_records_summary = {}
    if @user.sleep_records_viewable_by?(current_user)
      sleep_records_summary = @user.sleep_records_summary
    end
  
    render json: {
      email: @user.email,
      full_name: @user.profile&.full_name,
      followers_count: @user.followers.count,
      following_count: @user.following.count,
      followers: @user.followers_summary,
      followings: @user.following_summary(current_user),
    }.merge(sleep_records_summary), status: :ok
  end
  
  # PATCH /api/v1/users/:id
  # Updates a user's profile information
  def update
    load_user_with_profile
    if @user == current_user
      result = @user.update_profile(profile_params)
  
      if result[:status] == :ok
        render json: {
          profile: result[:profile],
          success: true,
          message: result[:message],
          followers_count: result[:followers_count],
          following_count: result[:following_count]
        }, status: result[:status]
      else
        render json: { success: false, errors: result[:errors] }, status: result[:status]
      end
    else
      render json: { success: false, error: "You are not authorized to update this profile." }, status: :unauthorized
    end
  end

  # POST /api/v1/users/:id/follow
  # Follows a user
  def follow
    user_to_follow = User.find_by(id: params[:id])
    
    if user_to_follow.nil?
      render json: { success: false, error: "User not found." }, status: :not_found
    elsif user_to_follow == current_user
      render json: { success: false, error: "You cannot follow yourself." }, status: :unprocessable_entity
    elsif current_user.following.include?(user_to_follow)
      render json: { success: false, error: "You are already following this user." }, status: :unprocessable_entity
    else
      current_user.following << user_to_follow
      render json: { success: true, message: "You are now following #{user_to_follow.email}." }, status: :ok
    end
  end
  
  # DELETE /api/v1/users/:id/follow
  # Unfollows a user
  def unfollow
    if @user.nil?
      render json: { success: false, error: "User not found." }, status: :not_found
    elsif @user == current_user
      render json: { success: false, error: "You cannot unfollow yourself." }, status: :unprocessable_entity
    elsif !current_user.following.include?(@user)
      render json: { success: false, error: "You are not following this user." }, status: :unprocessable_entity
    else
      current_user.following.delete(@user)
      render json: { success: true, message: "You have unfollowed #{@user.email}." }, status: :ok
    end
  end

  # POST /api/v1/users/:id/clock_in
  # Clocks a user in for sleep tracking
  def clock_in
    if params[:id].to_i == current_user.id
      last_sleep = current_user.sleeps.order(start_time: :desc).first
  
      if last_sleep.nil? || last_sleep.end_time.present?
        sleep_record = current_user.sleeps.create(start_time: Time.now)
  
        render json: { success: true, message: 'Clock in successful.', sleep: sleep_record }, status: :created
      else
        render json: { success: false, message: 'You must clock out before clocking in again.' }, status: :unprocessable_entity
      end
    else
      render json: { success: false, message: 'You are not authorized to perform this action.' }, status: :unauthorized
    end
  end
  
  # POST /api/v1/users/:id/clock_out
  # Clocks a user out for sleep tracking
  def clock_out
    if params[:id].to_i == current_user.id
      last_sleep = current_user.sleeps.order(start_time: :desc).first
  
      if last_sleep.present? && last_sleep.end_time.nil?
        last_sleep.update(end_time: Time.now)
  
        render json: { success: true, message: 'Clock out successful.', sleep: last_sleep }, status: :ok
      else
        render json: { success: false, message: 'You must clock in before clocking out.' }, status: :unprocessable_entity
      end
    else
      render json: { success: false, message: 'You are not authorized to perform this action.' }, status: :unauthorized
    end
  end
  
  private

  def load_user_with_profile
    @user = User.includes(:profile).find(params[:id])
  end

  # Helper method to set the user object based on the id parameter
def set_user
  @user = User.find_by(id: params[:id])
  if @user.nil?
    render json: { success: false, error: "User not found." }, status: :not_found
  end
end

  # Helper method to permit profile parameters for update action
  def profile_params
    params.require(:profile).permit(:first_name, :last_name)
  end
end
