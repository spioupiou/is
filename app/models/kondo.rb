class Kondo < ApplicationRecord
  belongs_to :user
  has_many :users, through: :bookings

  validates :name, :summary, :details, presence: true
end
