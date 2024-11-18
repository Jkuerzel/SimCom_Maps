class AddUnitsPerHourToResources < ActiveRecord::Migration[7.1]
  def change
    add_column :resources, :units_per_hour, :decimal
  end
end
