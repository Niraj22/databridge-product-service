class CreateInventories < ActiveRecord::Migration[7.1]
  def change
    create_table :inventories do |t|
      t.references :product, null: false, foreign_key: true
      t.integer :quantity
      t.integer :low_stock_threshold

      t.timestamps
    end
  end
end
