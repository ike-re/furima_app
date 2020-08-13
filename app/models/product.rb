class Product < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  validates_associated :photos
  validates :name, :introduction, :size_id, :condition_id,
            :postage_payer_id, :prefecture_code, :prep_date_id,
            :price, :trading_status, :seller_id,
            :photos, presence: true
  validates :name, length: { maximum: 40}
  validates :introduction, length: { maximum: 1000}
  validates :price, numericality: { only_integer:true, greater_than_or_equal_to:300, less_than_or_equal_to:9999999}
  has_many :photos, dependent: :destroy
  belongs_to :brand, optional: true
  belongs_to :seller, class_name: 'User', optional: true
  belongs_to :buyer, class_name: 'User', optional: true
  belongs_to :category
  belongs_to_active_hash :size
  belongs_to_active_hash :condition
  belongs_to_active_hash :postage_payer
  belongs_to_active_hash :prep_date
  accepts_nested_attributes_for :photos, allow_destroy: true
  accepts_nested_attributes_for :brand
  scope :key_search, -> (search) { Product.where('name LIKE(?)', "%#{search}%") }
  scope :prev_search, -> (product) { Product.where("id < ?", product.id).last }
  scope :next_search, -> (product) { Product.where("id > ?", product.id).first }
  enum prefecture_code: {
    北海道:1,青森県:2,岩手県:3,宮城県:4,秋田県:5,山形県:6,福島県:7,
    茨城県:8,栃木県:9,群馬県:10,埼玉県:11,千葉県:12,東京都:13,神奈川県:14,
    新潟県:15,富山県:16,石川県:17,福井県:18,山梨県:19,長野県:20,
    岐阜県:21,静岡県:22,愛知県:23,三重県:24,
    滋賀県:25,京都府:26,大阪府:27,兵庫県:28,奈良県:29,和歌山県:30,
    鳥取県:31,島根県:32,岡山県:33,広島県:34,山口県:35,
    徳島県:36,香川県:37,愛媛県:38,高知県:39,
    福岡県:40,佐賀県:41,長崎県:42,熊本県:43,大分県:44,宮崎県:45,鹿児島県:46,沖縄県:47
  }

  enum trading_status: {
    出品中:1,売却済み:2
  }
end
