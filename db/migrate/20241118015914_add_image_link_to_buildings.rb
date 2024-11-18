class AddImageLinkToBuildings < ActiveRecord::Migration[7.1]
  def change
    add_column :buildings, :image_link, :string
  end
end
