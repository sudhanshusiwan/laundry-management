class CreateClothTypes < ActiveRecord::Migration
  def change
    create_table :cloth_types do |t|
      t.string :name, null: false
      t.float :laundry_price, null: false
      t.float :dryclean_price, null: false

      t.timestamps null: false
    end
  end
end
