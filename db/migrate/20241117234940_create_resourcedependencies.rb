class CreateResourcedependencies < ActiveRecord::Migration[7.1]
  def change
    create_table :resourcedependencies do |t|
      t.integer :product_id
      t.integer :input_id
      t.float :quantity_required

      t.timestamps
    end
  end
end
