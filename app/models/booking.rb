class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :kondo

  enum status: { waiting: 'waiting', confirmed: 'confirmed', declined: 'declined', completed: 'completed' }
  validates :booked_date, presence: true
  validate :booked_date_is_a_date
  validate :booked_date_three_days_prior
  validate :booked_date_too_far

  private

  def booked_date_is_a_date
    return if booked_date.nil?

    errors.add(:booked_date, 'must be a valid date') unless booked_date.is_a?(Date)
  end

  def booked_date_three_days_prior
    return if booked_date.nil?

    if booked_date < Date.today + 3
      errors.add(:booked_date, "must be booked 3 days in advance")
    end
  end

  def booked_date_too_far
    return if booked_date.nil?

    if booked_date > Date.today + 365
      errors.add(:booked_date, 'cannot book too far in advance')
    end
  end
end
