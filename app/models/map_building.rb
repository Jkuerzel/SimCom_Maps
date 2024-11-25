# == Schema Information
#
# Table name: map_buildings
#
#  id                         :bigint           not null, primary key
#  level                      :integer
#  production_buildings_count :integer
#  production_time            :integer
#  quality_level              :integer
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  building_id                :integer
#  map_id                     :integer
#  position_id                :integer
#  product_id                 :integer
#
class MapBuilding < ApplicationRecord
  #Add Direct Associations
  belongs_to :building_type, required: true, class_name: "Building", foreign_key: "building_id", counter_cache: true
  belongs_to :product, class_name: "Resource", foreign_key: "product_id"
  belongs_to :user_map, required: true, class_name: "Map", foreign_key: "map_id", counter_cache: true

  #Add Indirect Associations
  has_one  :outcome_price, through: :product, source: :prices
  #Add Validations

  # Ensure `position_id` is within the allowed range
  validates :position_id, inclusion: { in: 1..18, message: "must be between 1 and 18" }
  # Ensure `position_id` is unique per `map_id`
  validates :position_id, uniqueness: { scope: :map_id, message: "already taken for this map" }
  validates :level, presence: true

  def required_amount(input_id)
    # Ensure the product has dependant_resources and fetch the quantity required
    self.product.dependant_resources.find_by(input_id: input_id)&.quantity_required || 0
  end

  # Increment the level
  def increment_level
    update(level: level + 1)
  end

  # Decrement the level, ensuring it doesn't go below 0 (optional)
  def decrement_level
    update(level: [level - 1, 0].max)
  end

  # Increment the level
  def increment_quality
    update(quality_level: [quality_level + 1, 12].min)
  end

  # Decrement the level, ensuring it doesn't go below 0 (optional)
  def decrement_quality
    update(quality_level: [quality_level - 1, 0].max)
  end

end
