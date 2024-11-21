# == Schema Information
#
# Table name: maps
#
#  id                  :bigint           not null, primary key
#  executives_count    :integer
#  map_buildings_count :integer
#  name                :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  owner_id            :integer
#
class Map < ApplicationRecord
  #Add Direct Associations
  belongs_to :owner, required: true, class_name: "User", foreign_key: "owner_id", counter_cache: true
  has_many  :comments, class_name: "Comment", foreign_key: "map_id", dependent: :destroy
  has_many  :likes, class_name: "Like", foreign_key: "map_id", dependent: :destroy
  has_many  :map_buildings, class_name: "MapBuilding", foreign_key: "map_id", dependent: :destroy
  has_many  :executives, class_name: "Executive", foreign_key: "map_id", dependent: :destroy
  #Add Indirect Associations
  has_many :building_types, through: :map_buildings, source: :building_type
  #Add Validations
  validates :owner_id, presence: true
  validates :name, presence: true

  

  def total_profit
    map_buildings = self.map_buildings.includes(:product, :building_type) # Preload associations
  
    total_profit = 0
  
    map_buildings.each do |map_building|
      # Determine minimum input quality
      minimum_input_quality = [map_building.quality_level - 1, 0].max
  
      # Calculate units produced per hour
      units_produced_per_hour = map_building.product.units_per_hour * map_building.level
  
      cost_per_unit = 0
  
      # Calculate cost per unit from inputs
      map_building.product.inputs.each do |input|
        amount = map_building.product.dependant_resources.find_by(input_id: input.id)&.quantity_required || 0
        input_price = input.prices.find_by(quality_level: minimum_input_quality)&.price || 0
  
        cost_per_unit += amount * input_price
      end
  
      # Calculate product price for quality level
      product_price = map_building.product.price_for_quality(map_building.quality_level)
  
      # Daily calculations
      units_per_day = units_produced_per_hour * 24
      revenue_per_day = units_per_day * product_price
      wage_cost_per_day = map_building.building_type.wage_cost_per_hour * 24
      cost_of_input_per_day = cost_per_unit * units_per_day
      profit_per_day = revenue_per_day - wage_cost_per_day - cost_of_input_per_day
  
      # Accumulate total profit
      total_profit += profit_per_day
    end
  
    total_profit
  end
end
