class AddSomeFieldsToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :to_pick_date, :date
    add_column :orders, :to_pick_time, :time
    add_column :orders, :address_id, :integer, null: false
  end
end
