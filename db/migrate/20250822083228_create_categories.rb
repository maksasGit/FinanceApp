class CreateCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.string :category_type, null: false
      t.references :user, null: false, foreign_key: true
      t.references :parent, foreign_key: { to_table: :categories }
      t.timestamps
    end
  end
end
