class AddImagelinkToResources < ActiveRecord::Migration[7.1]
  def change
    add_column :resources, :image_link, :string
  end
end
