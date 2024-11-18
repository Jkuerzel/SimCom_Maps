class CreateBuildings < ActiveRecord::Migration[7.1]
  def change
    create_table :buildings do |t|
      t.string :name
      t.float :wage_cost_per_hour
      t.float :construction_price
      t.string :description
      t.integer :map_buildings_count

      t.timestamps
    end
  end
end
