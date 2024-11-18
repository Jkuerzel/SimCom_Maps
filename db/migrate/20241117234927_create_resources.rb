class CreateResources < ActiveRecord::Migration[7.1]
  def change
    create_table :resources do |t|
      t.string :name
      t.float :transport_amount
      t.integer :building_id
      t.time :production_time_per_unit

      t.timestamps
    end
  end
end
