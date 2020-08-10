class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string     :name,             null: false
      t.text       :introduction,     null: false
      t.integer    :size_id,          null: false
      t.references :brand,            foreign_key: true
      t.integer    :condition_id,     null: false
      t.integer    :postage_payer_id, null: false
      t.integer    :prefecture_code,  null: false
      t.integer    :prep_date_id,     null: false
      t.integer    :price,            null: false
      t.integer    :trading_status,   null: false, default: 1
      t.string     :closed_deal_date
      t.integer    :seller_id,        null: false
      t.integer    :buyer_id
      t.timestamps
    end
  end
end