class CreateCars < ActiveRecord::Migration[8.0]
  def change
    create_table :cars do |t|
      t.references :make, null: false, foreign_key: true
      t.references :model, null: false, foreign_key: true
      t.integer :year
      t.integer :price
      t.integer :mileage
      t.string :condition
      t.string :body_style
      t.string :fuel_type
      t.string :transmission
      t.string :color
      t.text :description
      t.jsonb :specs
      t.references :user, null: false, foreign_key: true
      t.string :status
      t.datetime :published_at

      t.timestamps
    end
  end
end
