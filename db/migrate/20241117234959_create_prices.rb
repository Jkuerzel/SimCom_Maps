class CreatePrices < ActiveRecord::Migration[7.1]
  def change
    create_table :prices do |t|
      t.integer :resource_id
      t.string :quality_level
      t.float :price

      t.timestamps
    end
  end
end
