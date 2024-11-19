class DropProductionrunsTable < ActiveRecord::Migration[7.1]
  def up
    drop_table :productionruns, if_exists: true
  end

  def down
    create_table :productionruns, if_not_exists: true do |t|
      t.integer :product_id
      t.integer :quality_level
      t.integer :production_time
      t.integer :map_building_id
      t.timestamps
    end
  end
end
