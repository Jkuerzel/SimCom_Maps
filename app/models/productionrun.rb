# == Schema Information
#
# Table name: productionruns
#
#  id              :bigint           not null, primary key
#  production_time :time
#  quality_level   :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  map_building_id :integer
#  product_id      :integer
#
class Productionrun < ApplicationRecord
  #Add Direct Associations
  belongs_to :product, required: true, class_name: "Resource", foreign_key: "product_id"
  belongs_to :map_building, required: true, class_name: "MapBuilding", foreign_key: "map_building_id"
  #Add Indirect Associations
  has_one  :production_price, through: :product, source: :prices
  #Add Validations
end
