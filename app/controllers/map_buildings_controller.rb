class MapBuildingsController < ApplicationController
  def index
    matching_map_buildings = MapBuilding.all

    @list_of_map_buildings = matching_map_buildings.order({ :created_at => :desc })

    render({ :template => "map_buildings/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_map_buildings = MapBuilding.where({ :id => the_id })

    @the_map_building = matching_map_buildings.at(0)

    if @the_map_building.quality_level>0
      @minimum_input_quality=@the_map_building.quality_level - 1
    else
      @minimum_input_quality=@the_map_building.quality_level
    end

    units_produced_per_hour=@the_map_building.product.units_per_hour * @the_map_building.level
    
    @cost_per_unit=0

    @the_map_building.product.inputs.each do |input|
      amount = @the_map_building.product.dependant_resources.where(input_id: input.id).first&.quantity_required
    
      if input.prices.where(quality_level: @minimum_input_quality).exists?
        @input_price=(input.prices.where(quality_level: @minimum_input_quality).first.price).round(2)
      else
        @input_price=0
      end
      
      @cost_per_unit=(@cost_per_unit+amount*@input_price).round(2)
    end

    #@product_price = (@the_map_building.outcome_price.price).round(2)
    #@product_price=Price.where({:resource_id=>@the_map_building.product}).where({:quality_level=>@the_map_building.quality_level}).first.price.round(2)
    @product_price=@the_map_building.product.price_for_quality(@the_map_building.quality_level).round(2)
    

    @units_per_day=units_produced_per_hour*24
    @revenue_per_day=(units_produced_per_hour*@product_price*24).round(2)
    @wage_cost_per_day=(@the_map_building.building_type.wage_cost_per_hour*24).round(2)
    @cost_of_input_per_day=(@cost_per_unit * units_produced_per_hour*24).round(2)
    @profit_per_day=(@revenue_per_day-@wage_cost_per_day-@cost_of_input_per_day).round(2)
    
    @transport_amount_per_unit=@the_map_building.product.transport_amount

    render({ :template => "map_buildings/show" })
    
  end


  def create
    the_map_building = MapBuilding.new
    the_map_building.map_id = params.fetch("map_id")
    the_map_building.building_id = params.fetch("query_building_id")
    the_map_building.position_id = params.fetch("query_position_id")
    the_map_building.level = 1
    the_map_building.quality_level = 0
    the_map_building.production_time = 24
    the_map_building.abundance = 100

    product_id=Building.where({:id=>params.fetch("query_building_id")}).first.products.first.id

    the_map_building.product_id = product_id
    
    if the_map_building.valid?
      the_map_building.save
      redirect_to("/maps/#{the_map_building.map_id}", notice: "Map building created successfully.")
    else
      redirect_to("/maps/#{the_map_building.map_id}", alert: the_map_building.errors.full_messages.to_sentence)
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_map_building = MapBuilding.where({ :id => the_id }).at(0)
  
    the_map_building.map_id = params.fetch("query_map_id").to_i
    the_map_building.building_id = params.fetch("query_building_id").to_i
    the_map_building.position_id = params.fetch("query_position_id").to_i 
    the_map_building.level = params.fetch("query_level", 1).to_i
    the_map_building.production_time = params.fetch("query_production_time")
    the_map_building.quality_level = params.fetch("query_quality_level").to_i
    the_map_building.product_id = params.fetch("query_product_id")
  
    if the_map_building.valid?
      the_map_building.save
      redirect_to("/maps/#{the_map_building.map_id}", { :notice => "Map building updated successfully."} )
    else
      Rails.logger.debug("Validation Errors: #{the_map_building.errors.full_messages}")
      redirect_to("/map_buildings/#{the_map_building.id}", { :alert => the_map_building.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("map_building_id")
    map_id = params.fetch("map_id")
    the_map_building = MapBuilding.where({ :id => the_id }).at(0)

    the_map_building.destroy

    redirect_to("/maps/#{map_id}", { :notice => "Map building deleted successfully."} )
  end

  def update_level
    the_id = params.fetch("path_id")
    the_map_building = MapBuilding.where({ :id => the_id }).at(0)
  
    the_map_building.level = params.fetch("query_level")

    if the_map_building.valid?
      the_map_building.save
      redirect_to("/map_buildings/#{the_map_building.id}", { :notice => "Map building updated successfully."} )
    else
      redirect_to("/map_buildings/#{the_map_building.id}", { :alert => the_map_building.errors.full_messages.to_sentence })
    end
  end
  
  def update_type
    the_id = params.fetch("path_id")
    the_map_building = MapBuilding.where({ :id => the_id }).at(0)
    the_map_id= params.fetch("map_id")
    the_map_building.building_id = params.fetch("query_building_id")
    product_id=Building.where({:id=>params.fetch("query_building_id")}).first.products.first.id
    the_map_building.product_id = product_id
  
    if the_map_building.valid?
      the_map_building.save
      redirect_to("/maps/#{the_map_id}", { :notice => "Map building updated successfully."} )
    else
      redirect_to("/maps/#{the_map_id}", { :alert => the_map_building.errors.full_messages.to_sentence })
    end
  end

  def update_product
    the_id = params.fetch("path_id")
    the_map_building = MapBuilding.where({ :id => the_id }).at(0)
  
    the_map_building.product_id = params.fetch("query_product_id")
  
    if the_map_building.valid?
      the_map_building.save
      redirect_to("/map_buildings/#{the_map_building.id}", { :notice => "Map building updated successfully."} )
    else
      redirect_to("/map_buildings/#{the_map_building.id}", { :alert => the_map_building.errors.full_messages.to_sentence })
    end
  end

  def update_quality
    the_id = params.fetch("path_id")
    the_map_building = MapBuilding.where({ :id => the_id }).at(0)
  
    the_map_building.quality_level = params.fetch("query_quality_level")
  
    if the_map_building.valid?
      the_map_building.save
      redirect_to("/map_buildings/#{the_map_building.id}", { :notice => "Map building updated successfully."} )
    else
      redirect_to("/map_buildings/#{the_map_building.id}", { :alert => the_map_building.errors.full_messages.to_sentence })
    end
  end

  def increment_level
    the_id = params.fetch("path_id")
    the_map_building = MapBuilding.where({ :id => the_id }).at(0)
    if the_map_building.increment_level
      redirect_to("/maps/#{the_map_building.user_map.id}", { :notice => "Level updated successfully."} )
    else
      redirect_to("/maps/#{the_map_building.user_map.id}", { :notice => 'Failed to increase level.'} )
    end
  end

  def decrement_level
    the_id = params.fetch("path_id")
    the_map_building = MapBuilding.where({ :id => the_id }).at(0)

    if the_map_building.decrement_level
      redirect_to("/maps/#{the_map_building.user_map.id}", { :notice => "Level updated successfully."} )
    else
      redirect_to("/maps/#{the_map_building.user_map.id}", { :notice => 'Failed to decrease level.'} )
    end
  end

  def increment_quality
    the_id = params.fetch("path_id")
    the_map_building = MapBuilding.where({ :id => the_id }).at(0)
    if the_map_building.increment_quality
      redirect_to("/maps/#{the_map_building.user_map.id}", { :notice => "Quality updated successfully."} )
    else
      redirect_to("/maps/#{the_map_building.user_map.id}", { :notice => 'Failed to increase quality.'} )
    end
  end

  def decrement_quality
    the_id = params.fetch("path_id")
    the_map_building = MapBuilding.where({ :id => the_id }).at(0)

    if the_map_building.decrement_quality
      redirect_to("/maps/#{the_map_building.user_map.id}", { :notice => "Quality updated successfully."} )
    else
      redirect_to("/maps/#{the_map_building.user_map.id}", { :notice => 'Failed to decrease quality.'} )
    end
  end
end
