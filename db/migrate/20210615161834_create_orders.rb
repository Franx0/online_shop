class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.decimal :amount, precision: 10, scale: 2, default: "0.0", null: false
      t.decimal :disbursement, precision: 10, scale: 2, default: "0.0", null: false
      t.decimal :fee, precision: 10, scale: 2, default: "0.0", null: false
      t.belongs_to :shopper
      t.belongs_to :merchant
      t.datetime :completed_at

      t.timestamps
    end
  end
end
