class Kondo < ApplicationRecord
  belongs_to :user
  has_many :users, through: :bookings
  has_many :bookings # no dependent: :destroy, provider can't delete services with pending bookings

  validates :name, :summary, :details, presence: true
end
