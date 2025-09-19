class ChangeCategoryTypeToInt < ActiveRecord::Migration[8.0]
  def up
    change_column :categories, :category_type, :integer, default: 1, null: false
  end

  def down
    change_column :categories, :category_type, :string
  end
end
