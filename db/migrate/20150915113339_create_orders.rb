class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|

      t.integer :customer_id,      null: false
      t.datetime :order_time,     null: false
      t.integer :laundry_store_id
      t.integer :dryclean_store_id
      t.integer :picker_id
      t.datetime :pickup_time
      t.integer :dropper_id
      t.datetime :drop_time
      t.string :status
      t.datetime :wash_comeplete_time

      t.timestamps null: false
    end
  end
end
