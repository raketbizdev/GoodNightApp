class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze

  validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }

  attr_accessor :token

  has_one :profile, dependent: :destroy
  has_many :sleeps, dependent: :destroy

  has_many :connections_as_follower, class_name: 'Connection', foreign_key: 'follower_id', dependent: :destroy
  has_many :connections_as_following, class_name: 'Connection', foreign_key: 'following_id', dependent: :destroy

  has_many :following, through: :connections_as_follower, source: :following
  has_many :followers, through: :connections_as_following, source: :follower

  # Determines if the current user can view the sleep records of the given user.
  def can_view_sleep_records?(current_user)
    self == current_user || (current_user.following.include?(self) && following.include?(current_user))
  end

  # Returns the sleep summary (total duration and sleep count) for the user.
  def sleep_summary
    valid_sleeps = sleeps.where.not(end_time: nil)
    total_duration = valid_sleeps.sum("EXTRACT(EPOCH FROM (end_time - start_time))")
    sleep_count = valid_sleeps.count

    {
      total_duration: total_duration,
      sleep_count: sleep_count
    }
  end

  # Returns the sleep records of the user ordered by created_at.
  def sleep_records
    sleeps.where.not(end_time: nil).order(created_at: :desc).map do |sleep|
      {
        id: sleep.id,
        start_time: sleep.start_time,
        end_time: sleep.end_time,
        duration: sleep.duration
      }
    end
  end

  # Returns the summary of the user's followings including their sleep records, total duration, and sleep count.
  def following_summary(current_user)
    following.map do |following|
      following_data = { id: following.id, name: following.profile.full_name }
      if following.following.include?(current_user)
        following_data.merge!(following.sleep_summary)
      end
      following_data
    end
  end

  # Returns the user summary including the sleep summary data.
  def user_summary
    sleep_summary_data = sleep_summary
    profile_name = profile.present? ? profile.full_name : nil

    {
      id: id,
      email: email,
      full_name: profile_name,
      followers_count: followers.count,
      followings_count: following.count,
      sleep_duration: sleep_summary_data[:total_duration],
      sleep_count: sleep_summary_data[:sleep_count],
      created_at: created_at
    }
  end

  def generate_jwt_token
    # Generate a JWT token for the user
    JWT.encode({ user_id: id }, Rails.application.secrets.secret_key_base, 'HS256')
  end


  private

  # Creates a profile for the user after registration.
  def create_profile
    profile = Profile.new(user_id: self.id)
  end


end