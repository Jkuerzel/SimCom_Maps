class CreateExecutives < ActiveRecord::Migration[7.1]
  def change
    create_table :executives do |t|
      t.integer :name
      t.integer :map_id
      t.integer :position
      t.integer :operations_level
      t.integer :finance_level
      t.integer :marketing_level
      t.integer :research_level
      t.float :salary

      t.timestamps
    end
  end
end
