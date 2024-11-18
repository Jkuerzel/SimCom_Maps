class CreateComments < ActiveRecord::Migration[7.1]
  def change
    create_table :comments do |t|
      t.integer :user_id
      t.string :comment_text
      t.integer :map_id

      t.timestamps
    end
  end
end
