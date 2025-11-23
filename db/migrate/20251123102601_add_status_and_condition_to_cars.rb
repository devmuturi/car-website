class AddStatusAndConditionToCars < ActiveRecord::Migration[8.0]
  def change
    remove_column :cars, :status, :string if column_exists?(:cars, :status)
    remove_column :cars, :condition, :string if column_exists?(:cars, :condition)
    add_column :cars, :status, :integer, default: 0
    add_column :cars, :condition, :integer, default: 0
    add_index :cars, :status
    add_index :cars, :condition
  end
end
