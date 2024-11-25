class AddBonusToMaps < ActiveRecord::Migration[6.1]
  def change
    # Add the new column with a default value and not allowing null values
    add_column :maps, :bonus, :integer, default: 0, null: false

    # Update existing records to have bonus of 0 (this is optional since default is set)
    reversible do |dir|
      dir.up { Map.update_all(bonus: 0) }
    end
  end
end
