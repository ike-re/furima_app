# README

## Usersテーブル
|Column|Type|Options|
|------|----|-------|
|nickname|string|null: false, unique: true|
|email|string|null: false, unique: true|
|first_name|string|null: false|
|family_name|string|null: false|
|first_name_kana|string|null: false|
|family_name_kana|string|null: false|
|birth_date|date|null: false|
|introduction|text||
|icon|string||
### Association
- has_many :comments, dependent: :destroy
- has_many :favorites, dependent: :destroy
- has_many :user_evaluations
- has_one :deliver_address, dependent: :destroy
- has_one :creditcard, dependent: :destroy
- has_many :products, through: :favorites



## CreditCardsテーブル
|Column|Type|Options|
|------|----|-------|
|customer_id|string|null: false|
|card_id|string|null: false|
|user|references|null: false, foreign_key: true|
### Association
- belongs_to :user



## Deliver_addressesテーブル
|Column|Type|Options|
|------|----|-------|
|post_code|integer|null: false|
|prefecture_code|integer|null: false|
|city|string|null: false|
|house_number|string|null: false|
|building_name|string||
|phone_number|integer|unique: true|
|user|references|null: false, foreign_key: true|
|destination_first_name|string|null: false|
|destination_family_name|string|null:false|
|destination_first_name_kana|string|null: false|
|destination_family_name_kana|string|null: false|
### Association
- belongs_to :user



## User_evaluationsテーブル
|Column|Type|Options|
|------|----|-------|
|user|references|null: false, foreign_key: true|
|product|references|null: false, foreign_key: true|
|evaluation|references|null: false, foreign_key: true|
|review|text||
### Association
- belongs_to_active_hash :evaluation
- belongs_to :user
- belongs_to :product



## Commentsテーブル
|Column|Type|Options|
|------|----|-------|
|user|references|null: false, foreign_key: true|
|product|references|null: false, foreign_key: true|
|text|text|null: false|
### Association
- belongs_to :user
- belongs_to :product



## Favoritesテーブル
|Column|Type|Options|
|------|----|-------|
|user|references|null: false, foreign_key: true|
|product|references|null: false, foreign_key: true|
### Association
- belongs_to :user
- belongs_to :product



## Productsテーブル
|Column|Type|Options|
|------|----|-------|
|name|string|null: false|
|introduction|text|null: false|
|size_id|integer|null: false|
|brand|references|foreign_key: true|
|condition_id|integer|null: false|
|postage_payer_id|integer|null: false|
|prefecture_code|integer(enum)|null: false|
|prep_date_id|integer|null: false|
|price|integer|null: false|
|trading_status|integer(enum)|null: false, default: 1|
|closed_deal_date|string|
|seller_id|integer|null: false|
|buyer_id|integer||
### Association
- has_many :photos, dependent: :destroy
- has_many :comments, dependent: :destroy
- has_many :favorites, dependent: :destroy
- has_many :users, through: :favorites
- has_many :categories_products, dependent: :destroy
- has_many :categories, through: :categories_products
- has_one :user_evaluation
- belongs_to :brand
- belongs_to_active_hash :size
- belongs_to_active_hash :condition
- belongs_to_active_hash :postage_payer
- belongs_to_active_hash :prep_date
- belongs_to :seller, class_name :"User"
- belongs_to :buyer, class_name :"User"


## Photosテーブル
|Column|Type|Options|
|------|----|-------|
|image|string|null: false|
|product|references|null: false, foreign_key: true|
### Association
- belongs_to :product


## Brandsテーブル
|Column|Type|Options|
|------|----|-------|
|name|string|null: false|
### Association
- has_many :products


## Categoriesテーブル
|Column|Type|Options|
|------|----|-------|
|name|string|null: false|
|ancestry|string||
### Association
- has_many :categories_products, dependent: :destroy
- has_many :products, through: :categories_products

## Categories_Productsテーブル
|Column|Type|Options|
|------|----|-------|
|category|references|foreign_key: true|
|product|references|foreign_key: true|
### Association
- belongs_to :category
- belongs_to :product



This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
