class RemoveForeignKeyFromProducts < ActiveRecord::Migration[6.0]
  def change
    remove_foreign_key :products, :brands
  end
end
