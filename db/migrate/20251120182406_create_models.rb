class CreateModels < ActiveRecord::Migration[8.0]
  def change
    create_table :models do |t|
      t.references :make, null: false, foreign_key: true
      t.string :name
      t.string :generation

      t.timestamps
    end
  end
end
