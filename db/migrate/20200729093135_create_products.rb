class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.integer    :price,           null: false
      t.string     :name,            null: false
      t.text       :introduction,    null: false
      t.references :condition,       foreign_key: true
      t.references :brand,           foreign_key: true
      t.references :category,        foreign_key: true
      t.references :seller,          foreign_key: true
      t.references :buyer,           foreign_key: true
      t.enum       :trading_status,   null: false
      t.string     :closed_deal_date
      t.references :size,            foreign_key: true
      t.integer    :shipping_fee,     null: false
      t.integer    :prefecture_code,  null: false
      t.string     :postage_payer,    null: false
      t.timestamps
    end
  end
end
