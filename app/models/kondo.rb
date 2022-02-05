class Kondo < ApplicationRecord
  belongs_to :user
  has_many :users, through: :bookings
  has_many :bookings # no dependent: :destroy, provider can't delete services with pending bookings
  has_one_attached :photo
  acts_as_taggable_on :tags

  include PgSearch::Model
    pg_search_scope :global_search,
      against: [ :prefecture ],
      associated_against: {
        tags: [:name]
      },
      using: {
        tsearch: {any_word: true}
      }

  $categories = ["designers", "keepers", "others"]
  $prefectures = %w[Chiba Kyoto Osaka Tokyo]

  validates :name, :summary, :details, :service_duration, presence: true
end
