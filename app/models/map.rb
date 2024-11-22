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

  def production
    # Fetch the transport unit price from a specific resource (e.g., ID 13)
    transport_unit_price = Price.where(resource_id: 13).first.price rescue 0.0
  
    # Initialize ledger for all resources
    @ledger = Hash.new { |hash, key| hash[key] = Hash.new { |h, q| h[q] = { produced: 0, consumed: 0, excess: 0, shortfall: 0, purchased: 0, price: nil, transport_per_unit: 0, fee_paid: 0, transport_needed: 0, transport_cost: 0, revenue: 0 } } }
  
    # Step 1: Populate Produced Resources and Fetch Product Prices
    self.map_buildings.each do |the_map_building|
      product_id = the_map_building.product_id
      quality = the_map_building.quality_level
      @units_per_day = (the_map_building.product.units_per_hour * the_map_building.level * 24).round(2)
  
      # Add production to ledger
      @ledger[product_id][quality][:produced] += @units_per_day
  
      # Fetch and assign product price
      product_price = the_map_building.product.price_for_quality(quality) rescue 0.0
      @ledger[product_id][quality][:price] = product_price
  
      # Fetch and assign transport per unit
      transport_per_unit = the_map_building.product.transport_amount
      @ledger[product_id][quality][:transport_per_unit] = transport_per_unit
  
      # Debug: Show product price and transport amount
      puts "Product Price for Resource #{product_id} at Quality #{quality}: #{product_price}"
      puts "Transport Per Unit for Resource #{product_id} at Quality #{quality}: #{transport_per_unit}"
    end
  
    # Step 1.1: Initialize All Inputs and Fetch Input Prices and Transport Amounts
    self.map_buildings.each do |the_map_building|
      the_map_building.product.inputs.each do |input|
        input_id = input.id
        (0..12).each do |quality| # Assuming qualities range from 0 to 12
          price_value = input.price_for_quality(quality) rescue 0.0 # Default to 0.0 if no price is found
          transport_per_unit = input.transport_amount
          @ledger[input_id][quality][:price] = price_value
          @ledger[input_id][quality][:transport_per_unit] = transport_per_unit
        end
      end
    end
  
    # Step 2: Populate Consumed Resources and Purchases
    self.map_buildings.each do |the_map_building|
      product_id = the_map_building.product_id
      quality = the_map_building.quality_level
      produced_amount = @ledger[product_id][quality][:produced] # Amount produced at this quality
  
      # Process each input required by the product
      the_map_building.product.inputs.each do |input|
        input_id = input.id
        dependency = the_map_building.product.dependant_resources.find_by(input_id: input.id)
  
        next unless dependency # Skip if no dependency is defined
  
        input_quantity_required = dependency.quantity_required
  
        # Calculate required input based on the produced amount
        required_amount = input_quantity_required * produced_amount
  
        # Determine the minimum quality required for this input
        required_quality = [quality - 1, 0].max # Minimum input quality
        remaining_needed = required_amount
  
        # Debug: Show initial requirement
        puts "Processing Input ID #{input_id} for Building ID #{the_map_building.id}..."
        puts "Required Quality: #{required_quality}, Required Amount: #{required_amount}"
  
        # Use available production (prioritize lower quality)
        @ledger[input_id].keys.sort.each do |available_quality|
          # Skip qualities that do not meet the minimum required quality
          next if available_quality < required_quality
  
          # Calculate available amount
          available_amount = @ledger[input_id][available_quality][:produced] - @ledger[input_id][available_quality][:consumed]
  
          if available_amount > 0
            allocation = [available_amount, remaining_needed].min
            @ledger[input_id][available_quality][:consumed] += allocation
            remaining_needed -= allocation
  
            # Debug: Show allocation
            puts "Allocated #{allocation} from Quality #{available_quality} of Resource #{input_id} for Product #{product_id}."
            puts "Remaining Needed for Resource #{input_id}: #{remaining_needed}"
  
            # Stop consuming if the requirement is fully met
            break if remaining_needed <= 0
          end
        end
  
        # Record purchases at the correct quality
        if remaining_needed > 0
          @ledger[input_id][required_quality][:shortfall] += remaining_needed
          @ledger[input_id][required_quality][:purchased] += remaining_needed
  
          # Debug: Show purchased amounts
          puts "Purchased #{remaining_needed} of Resource #{input_id} at Quality #{required_quality} for Product #{product_id}."
        end
      end
    end
  
    # Step 3: Calculate Excess, Transport Costs, and Revenue
    @ledger.each do |resource_id, qualities|
      qualities.each do |quality, flow|
        flow[:excess] = flow[:produced] - flow[:consumed]
        flow[:fee_paid] = flow[:price] * flow[:excess] * 0.03
        flow[:transport_needed] = flow[:transport_per_unit] * flow[:excess]
        flow[:transport_cost] = flow[:transport_needed] * transport_unit_price
        flow[:revenue] = flow[:price] * flow[:excess]
      end
    end
  
    # Step 4: Remove Empty Rows
    @ledger.each do |resource_id, qualities|
      qualities.delete_if do |quality, flow|
        flow[:produced] == 0 && flow[:consumed] == 0 && flow[:excess] == 0 && flow[:shortfall] == 0 && flow[:purchased] == 0
      end
    end
    @ledger.delete_if { |resource_id, qualities| qualities.empty? }
  
    # Debug: Show final ledger
    puts "Final Ledger: #{@ledger.inspect}"
  
    @ledger
  end
  
  
  
  
  
  
  
  
  
  

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
