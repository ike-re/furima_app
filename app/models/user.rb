class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :nickname, :email, :first_name, :family_name,
            :first_name_kana, :family_name_kana,
            :birth_date, presence: true
  validates :email, uniqueness: true
  validates :first_name, :family_name,
            format: { with: /\A[ぁ-んァ-ン一-龥]/ }
  validates :first_name_kana, :family_name_kana,
            format: { with: /\A[ァ-ヶー－]+\z/ }
  validates :birth_date, format: { with: /\A\d{1,4}(\/|-)\d{1,2}\1\d{1,2}\z/ }
  has_many :selling_products, -> { where("buyer_id is NULL") }, foreign_key: "seller_id", class_name: "Product"
  has_many :comments
  has_one :deliver_address, dependent: :destroy
  has_one :credit_card, dependent: :destroy
end