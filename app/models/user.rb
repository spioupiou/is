class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :kondos
  has_many :bookings

  # no need for validates :role, inclusion: { in: ["renter", "provider"] }
  # cause enum already takes care of this validation too
  enum role: { provider: 'provider', renter: 'renter' }  

  validates :first_name, :last_name, presence: true
  # validates :prefecture, inclusion: { in: %w[Aichi Akita Aomori Chiba Ehime Fukui Fukuoka Fukushima Gifu Gunma Hiroshima
  #   Hokkaido Hyogo Ibaraki Ishikawa Iwate Kagawa Kagoshima Kanagawa
  #   Kochi Kumamoto Kyoto Mie Miyagi Miyazaki Nagano Nagasaki Nara Niigata
  #   Okayama Okinawa Oita Osaka Saga Saitama Shiga Shimane Shizuoka Tochigi
  #   Tokushima Tokyo Tottori Toyama Wakayama Yamagata Yamaguchi Yamanashi], allow_nil: false }
end
