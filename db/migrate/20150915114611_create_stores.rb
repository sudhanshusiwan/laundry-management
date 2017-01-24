class CreateStores < ActiveRecord::Migration
  def change
    create_table :stores do |t|
      t.string :name, null: false
      t.integer :area_id, null: false
      t.string :owner_id, null: false

      t.timestamps null: false
    end
  end
end
