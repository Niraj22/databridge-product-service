class CreateCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :categories do |t|
      t.string :name
      t.text :description
      t.integer :parent_id
      t.boolean :active

      t.timestamps
    end
  end
end
