# == Schema Information
#
# Table name: buildings
#
#  id                  :bigint           not null, primary key
#  construction_price  :float
#  description         :string
#  image_link          :string
#  map_buildings_count :integer
#  name                :string
#  wage_cost_per_hour  :float
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
class Building < ApplicationRecord
  #Add Direct Associations
  has_many  :map_buildings, class_name: "MapBuilding", foreign_key: "building_id", dependent: :destroy
  has_many  :products, class_name: "Resource", foreign_key: "building_id", dependent: :destroy
  #Add Indirect Associations
  has_many :user_maps, through: :map_buildings, source: :user_map
  #Add Validations
  validates :wage_cost_per_hour, presence: true
  validates :name, presence: true
  validates :construction_price, presence: true
end
