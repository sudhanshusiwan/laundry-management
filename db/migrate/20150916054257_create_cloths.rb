class CreateCloths < ActiveRecord::Migration
  def change
    create_table :cloths do |t|
      t.integer :cloth_type_id, null: false
      t.string :wash_type, null: false
      t.integer :count, null: false
      t.integer :order_id, null: false

      t.timestamps null: false
    end
  end
end
