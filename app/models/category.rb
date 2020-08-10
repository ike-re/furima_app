class Category < ApplicationRecord
  validates :name, presence: true
  has_many :products, dependent: :destroy
  has_ancestry
end