# == Schema Information
#
# Table name: maps
#
#  id                  :bigint           not null, primary key
#  bonus               :integer          default(0), not null
#  executives_count    :integer
#  map_buildings_count :integer
#  name                :string
#  operating_profit    :decimal(15, 2)   default(0.0)
#  total_revenue       :decimal(15, 2)   default(0.0)
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

  def admin_overhead
    #Filter out the recreation buildings
    production_buildings = self.map_buildings
      .joins(:building_type)
      .where.not(building_type: { description: 'Recreation' })
      .presence || []

    # Calculate total map level
    @total_map_levels = production_buildings.sum(:level)

    @ao_percentage = ((@total_map_levels - 1).to_f / 170)
    
    # Calculate COO impact
    # Calculate COO impact
    coo_levels=self.executives.where({:position=>1}).first.operations_level rescue 0.0
    # Calculate other C-Level staff impact
    staff_levels = self.executives.where(position: 2..4).sum(:operations_level).to_i / 4
    #Total exectuives impact
    executive_impact=(@ao_percentage/100)*(coo_levels+staff_levels)
    #Effective AO
    eff_ao_percentage=@ao_percentage-executive_impact

    {
      productive_levels: @total_map_levels,
      ao_percentage: @ao_percentage,  
      executive_impact: executive_impact,
      eff_ao_percentage: eff_ao_percentage
    }

  end

  def production
    # Fetch the transport unit price from a specific resource (e.g., ID 13)
    transport_unit_price = Price.where(resource_id: 13).first.price rescue 0.0
  

    #Filter out the recreation buildings
    production_buildings = self.map_buildings
      .joins(:building_type)
      .where.not(building_type: { description: 'Recreation' })
      .presence || []
    recreation_buildings = self.map_buildings
    .joins(:building_type)
    .where(building_type: { description: 'Recreation' })
    .presence || []

    # Ensure empty income statement and ledger for edge cases
    if production_buildings.empty?
      return {
        ledger: {},
        income_statement: {
          total_revenue: 0,
          total_cost_of_purchased_goods: 0,
          total_worker_wages: 0,
          cogs: 0,
          freight_out: 0,
          gross_income: 0,
          total_admin_overhead_wages: 0,
          executives_salaries: self.executives.all.sum(:salary),
          total_fees_paid: 0,
          operating_income: 0,
          administrative_overhead: 0,
          eff_administrative_overhead: 0
        }
      }
    end

    ###########################################
    # Calculating Adminstrative Overhead of Map
    ###########################################
    # Calculate total map level
    total_map_levels = production_buildings.sum(:level)
    # Calculate Base Level Administrative Overhead
    @ao_percentage = ((total_map_levels - 1).to_f / 170)
    # Calculate COO impact
    coo_levels=self.executives.where({:position=>1}).first.operations_level rescue 0.0
    # Calculate other C-Level staff impact
    staff_levels = self.executives.where(position: 2..4).sum(:operations_level).to_i / 4
    #Total exectuives impact
    executive_impact=(@ao_percentage/100)*(coo_levels+staff_levels)
    #Effective AO
    eff_ao_percentage=@ao_percentage-executive_impact

    ###########################################
    # Calculating Recreation Level ###########
    ###########################################
    recreation_levels = recreation_buildings.pluck(:level).compact.sum || 0
    recreation_factor = (100.0 + recreation_levels) / 100

    self.executives.where({:position=>1})

    # Initialize ledger for all resources
    @ledger = Hash.new { |hash, key| hash[key] = Hash.new { |h, q| h[q] = { produced: 0, consumed: 0, excess: 0, shortfall: 0, purchased: 0, price: nil, transport_per_unit: 0, fee_paid: 0, transport_needed: 0, transport_cost: 0, revenue: 0, wage_cost: 0, administration_wages: 0, cost_of_goods_purchased: 0, income_impact: 0 } } }
  


    # Step 1: Populate Produced Resources and Fetch Product Prices
    production_buildings.each do |the_map_building|
      product_id = the_map_building.product_id
      quality = the_map_building.quality_level
      @units_per_day = (the_map_building.product.units_per_hour * the_map_building.abundance/100 * the_map_building.level * 24 * recreation_factor).round(2)
      
      # Add production to ledger
      @ledger[product_id][quality][:produced] += @units_per_day
  
      # Fetch and assign product price
      product_price = the_map_building.product.price_for_quality(quality) rescue 0.0
      @ledger[product_id][quality][:price] = product_price
  
      # Fetch and assign transport per unit
      transport_per_unit = the_map_building.product.transport_amount
      @ledger[product_id][quality][:transport_per_unit] = transport_per_unit
  
      #Count in Effect of Robots
      if the_map_building.robots==true
        robots_factor=0.97
      else
        robots_factor=1
      end

      #Count in Effect of Recreational Buildings
      

      # Calculate and assign wage cost
      wage_cost_per_day = the_map_building.building_type.wage_cost_per_hour * the_map_building.level * ((100.0-self.bonus)/100) * robots_factor * 24
      @ledger[product_id][quality][:wage_cost] += wage_cost_per_day
  
      # Calculate administration wages
      worker_wages = wage_cost_per_day
      administration_wages = worker_wages * eff_ao_percentage
      @ledger[product_id][quality][:administration_wages] += administration_wages
  
      # Debug: Show product price, transport amount, wage cost, and administration wages
      puts "Product Price for Resource #{product_id} at Quality #{quality}: #{product_price}"
      puts "Transport Per Unit for Resource #{product_id} at Quality #{quality}: #{transport_per_unit}"
      puts "Wage Cost Per Day for Resource #{product_id} at Quality #{quality}: #{wage_cost_per_day}"
      puts "Administration Wages for Resource #{product_id} at Quality #{quality}: #{administration_wages}"
    end
  
    # Step 1.1: Initialize All Inputs and Fetch Input Prices and Transport Amounts
    production_buildings.each do |the_map_building|
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
    production_buildings.each do |the_map_building|
      product_id = the_map_building.product_id
      quality = the_map_building.quality_level

      # Calculate the produced amount for this specific building
      produced_amount = (the_map_building.product.units_per_hour * the_map_building.level * 24).round(2)

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
        flow[:cost_of_goods_purchased]=flow[:price] * flow[:purchased]
        flow[:income_impact]=flow[:revenue]-flow[:cost_of_goods_purchased]-flow[:transport_cost]-flow[:fee_paid]-flow[:wage_cost]-flow[:administration_wages]
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
  
    # Step 5: Calculate Income Statement
    @income_statement = {} # Initialize as an empty hash

    # Revenue
    @income_statement[:total_revenue] = @ledger.sum { |_, qualities| qualities.sum { |_, flow| flow[:revenue] } }

    # Cost of Purchased Goods
    @income_statement[:total_cost_of_purchased_goods] = @ledger.sum { |_, qualities| qualities.sum { |_, flow| flow[:cost_of_goods_purchased] } }

    # Worker Wages
    @income_statement[:total_worker_wages] = @ledger.sum { |_, qualities| qualities.sum { |_, flow| flow[:wage_cost] } }

    # COGS
    @income_statement[:cogs] = @income_statement[:total_cost_of_purchased_goods] + @income_statement[:total_worker_wages]

    # Freight Out (Transport Costs)
    @income_statement[:freight_out] = @ledger.sum { |_, qualities| qualities.sum { |_, flow| flow[:transport_cost] } }

    # Gross Income
    @income_statement[:gross_income] = @income_statement[:total_revenue] - @income_statement[:cogs] 

    # Operating Expenses
    @income_statement[:total_admin_overhead_wages] = @ledger.sum { |_, qualities| qualities.sum { |_, flow| flow[:administration_wages] } }
    @income_statement[:executives_salaries] = self.executives.all.sum(:salary)
    @income_statement[:total_fees_paid] = @ledger.sum { |_, qualities| qualities.sum { |_, flow| flow[:fee_paid] } }

    # Operating Income
    @income_statement[:operating_income] = @income_statement[:gross_income] - @income_statement[:total_admin_overhead_wages] - @income_statement[:executives_salaries] - @income_statement[:total_fees_paid]- @income_statement[:freight_out]


    #Administrative Overhead
    @income_statement[:administrative_overhead]=@ao_percentage
    @income_statement[:eff_administrative_overhead]=eff_ao_percentage
    @income_statement[:total_map_levels]=total_map_levels


    #Executives savings
    @income_statement[:executive_savings]=@income_statement[:total_worker_wages]*executive_impact


    # Debug: Display Income Statement
    puts "Income Statement:"
    @income_statement.each do |key, value|
      puts "#{key.to_s.humanize}: #{value.round(2)}"
    end

    @income_statement
    @ledger

    {
      ledger: @ledger,
      income_statement: @income_statement
    }
  end

  # Calculate total construction cost for all buildings in the map
  def total_construction_cost
    map_buildings.sum(&:construction_cost)
  end


  def total_scrap_value
    map_buildings.sum(&:scrap_value)
  end

  def total_robot_cost
    map_buildings.sum(&:robot_cost)
  end

  def total_robot_scrap_value
    map_buildings.sum(&:robot_scrap_value)
  end

end
