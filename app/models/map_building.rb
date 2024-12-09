# == Schema Information
#
# Table name: map_buildings
#
#  id                         :bigint           not null, primary key
#  abundance                  :integer          default(100), not null
#  level                      :integer
#  production_buildings_count :integer
#  production_time            :integer
#  quality_level              :integer
#  robots                     :boolean          default(FALSE), not null
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
  belongs_to :product, class_name: "Resource", foreign_key: "product_id", optional: true
  belongs_to :user_map, required: true, class_name: "Map", foreign_key: "map_id", counter_cache: true

  #Add Indirect Associations
  has_one  :outcome_price, through: :product, source: :prices
  #Add Validations

  # Ensure `position_id` is within the allowed range
  validates :position_id, inclusion: { in: 1..18, message: "must be between 1 and 18" }
  
  # Ensure `position_id` is unique per `map_id`
  validates :position_id, uniqueness: { scope: :map_id, message: "already taken for this map" }
  validates :position_id, uniqueness: { scope: :map_id, message: "Position must be unique within the same map" }

  #validates :quality_level, numericality: { 
    #only_integer: true, 
    #greater_than_or_equal_to: 0, 
    #less_than_or_equal_to: 12,
    #message: "must be between 0 and 12"
  #}

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

  def construction_cost
    base_price = self.building_type.construction_price
    level = self.level
    (level * (level + 1) / 2) * base_price
  end

  def scrap_value
    base_price = self.building_type.construction_price
    level = self.level
    level * base_price
  end

  def robot_cost

    # Total demand is construction price times the building's level
    total_demand = self.building_type.robot_demand * self.level

    # Determine the robot quality based on the level (1-3 => 1, 4-6 => 2, etc.)
    robot_quality = (self.level - 1) / 3 + 1

    # Robot price for the determined quality
    robot_price = Resource.where(name: "Robots").first.price_for_quality(robot_quality)

    # Calculate the total cost
    cost = total_demand * robot_price

    # Return the cost
    cost
  end

  def robot_scrap_value

    # Total demand is construction price times the building's level
    total_demand = self.building_type.robot_demand * self.level

    # Robot price for the determined quality
    robot_price = Resource.where(name: "Robots").first.price_for_quality(0)

    # Calculate the total cost
    cost = total_demand * robot_price

    # Return the cost
    cost
  end

end
