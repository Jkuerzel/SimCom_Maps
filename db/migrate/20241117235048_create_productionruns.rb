class CreateProductionruns < ActiveRecord::Migration[7.1]
  def change
    create_table :productionruns do |t|
      t.integer :product_id
      t.string :quality_level
      t.time :production_time
      t.integer :map_building_id

      t.timestamps
    end
  end
end
