class AddMapsCountToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :maps_count, :integer
  end
end
