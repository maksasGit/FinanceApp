class ChangeNameLimitInCategories < ActiveRecord::Migration[8.0]
  def up
    change_column :categories, :name, :string, limit: 30, null: false
  end

  def down
    change_column :categories, :name, :string, limit: nil, null: true
  end
end
