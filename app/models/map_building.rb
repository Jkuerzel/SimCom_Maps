# == Schema Information
#
# Table name: map_buildings
#
#  id          :bigint           not null, primary key
#  level       :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  building_id :integer
#  map_id      :integer
#  position_id :integer
#
class MapBuilding < ApplicationRecord
  #Add Direct Associations
  belongs_to :building_type, required: true, class_name: "Building", foreign_key: "building_id", counter_cache: true
  belongs_to :user_map, required: true, class_name: "Map", foreign_key: "map_id", counter_cache: true
  has_many  :productionruns, class_name: "Productionrun", foreign_key: "map_building_id", dependent: :destroy
  #Add Indirect Associations

  #Add Validations
  #validates :position_id, format: true
  #validates :position_id, uniqueness: true
  #validates :level, presence: true
  # Ensure `position_id` is within the allowed range
  validates :position_id, inclusion: { in: 1..18, message: "must be between 1 and 18" }
  # Ensure `position_id` is unique per `map_id`
  validates :position_id, uniqueness: { scope: :map_id, message: "already taken for this map" }
end
