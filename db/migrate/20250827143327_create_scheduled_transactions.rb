class CreateScheduledTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :scheduled_transactions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.references :currency, null: false, foreign_key: true

      t.decimal :amount, null: false, precision: 15, scale: 2
      t.string :description

      t.boolean :repeatable, null: false, default: false
      t.string :frequency, null: false, default: "once"
      t.datetime :start_date, null: false
      t.datetime :end_date
      t.integer :day_of_week
      t.integer :day_of_month

      t.datetime :next_execute_at, null: false
      t.boolean :active, null: false, default: true
      t.timestamps
    end

    add_index :scheduled_transactions, :next_execute_at
  end
end
