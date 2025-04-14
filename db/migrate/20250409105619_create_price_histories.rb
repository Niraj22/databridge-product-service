class CreatePriceHistories < ActiveRecord::Migration[7.1]
  def change
    create_table :price_histories do |t|
      t.references :product, null: false, foreign_key: true
      t.decimal :price
      t.datetime :effective_from
      t.datetime :effective_to

      t.timestamps
    end
  end
end
