class AddIndexesForUniqueFields < ActiveRecord::Migration[8.0]
  def change
    add_index :users, :email, unique: true
    add_index :currencies, :code, unique: true
  end
end
