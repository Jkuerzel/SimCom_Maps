class RemoveProductionTimePerUnitFromResources < ActiveRecord::Migration[7.1]
  def change
    remove_column :resources, :production_time_per_unit, :decimal
  end
end
