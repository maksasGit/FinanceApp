class CreateCurrencies < ActiveRecord::Migration[8.0]
  def change
    create_table :currencies do |t|
      t.string "code", null: false
      t.string "name", null: false
      t.decimal "decimal_places", precision: 2, scale: 0, null: false, default: 2
      t.timestamps
    end
  end
end
