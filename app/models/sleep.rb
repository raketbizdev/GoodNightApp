class Sleep < ApplicationRecord
  belongs_to :user

  # Calculates the duration of the sleep record.
  # If both start_time and end_time are present, it calculates the difference and returns the result as a float.
  # Otherwise, it returns 0.0.
  def duration
    (start_time && end_time) ? (end_time - start_time).to_f : 0.0
  end
end
