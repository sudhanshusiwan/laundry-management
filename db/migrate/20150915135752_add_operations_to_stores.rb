class AddOperationsToStores < ActiveRecord::Migration
  def change
    add_column :stores, :operations, :string
  end
end
