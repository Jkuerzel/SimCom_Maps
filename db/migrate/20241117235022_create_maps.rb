class CreateMaps < ActiveRecord::Migration[7.1]
  def change
    create_table :maps do |t|
      t.integer :owner_id
      t.string :name
      t.integer :map_buildings_count
      t.integer :executives_count

      t.timestamps
    end
  end
end
