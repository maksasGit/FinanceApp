class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.references :currency, null: false, foreign_key: true
      t.decimal :amount, precision: 12, scale: 0, null: false
      t.string :description
      t.datetime :transaction_date, null: false
      t.timestamps
    end
  end
end
