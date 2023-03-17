class Profile < ApplicationRecord
  belongs_to :user

  # Returns the full name of the user if both first_name and last_name are present.
  # Otherwise, it returns "No name".
  def full_name
    (first_name.blank? || last_name.blank?) ? "No name" : "#{first_name} #{last_name}"
  end

  # Updates the profile with the given params, and returns a hash containing the result of the update operation.
  # If the update is successful, the hash includes the updated profile, a success message, and the user's followers and following counts.
  # If the update fails, the hash includes the errors and a status of :unprocessable_entity.
  def update_profile(params)
    if update(params)
      {
        profile: self,
        message: "Profile updated successfully.",
        followers_count: user.followers.count,
        following_count: user.following.count,
        status: :ok
      }
    else
      { errors: errors.full_messages, status: :unprocessable_entity }
    end
  end
end