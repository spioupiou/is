class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :kondo

  enum status: { waiting: 'waiting', confirmed: 'confirmed', declined: 'declined', completed: 'completed' }
end
