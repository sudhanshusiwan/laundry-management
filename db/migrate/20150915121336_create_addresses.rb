class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|

      t.integer :owner_id, null: false
      t.string :line1, null: false
      t.string :line2
      t.integer :area_id, null:false
      t.string :city, null: false
      t.integer :pin, null: false

      t.timestamps null: false
    end
  end
end
