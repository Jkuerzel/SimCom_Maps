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
    the_map_building.robots = false

    if Building.where({:id=>params.fetch("query_building_id")}).first.description!="Recreation"
      product_id=Building.where({:id=>params.fetch("query_building_id")}).first.products.first.id
      the_map_building.product_id = product_id
    end

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
    
    if the_map_building.building_type.description!="Recreation"
      the_map_building.quality_level = params.fetch("query_quality_level").to_i
      the_map_building.product_id = params.fetch("query_product_id")
      the_map_building.robots = params.fetch("query_robots")
    end

    if [22, 23, 28].include?(the_map_building.building_type.id)
      the_map_building.abundance = params.fetch("query_abundance")
    else
      the_map_building.abundance = 100
    end
    
  
    if the_map_building.valid?
      the_map_building.save
      redirect_to("/maps/#{the_map_building.map_id}", { :notice => "Map building updated successfully."} )
    else
      Rails.logger.debug("Validation Errors: #{the_map_building.errors.full_messages}")
      redirect_to("/maps/#{the_map_building.id}", { :alert => the_map_building.errors.full_messages.to_sentence })
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
    the_map_building.abundance = 100
    if the_map_building.building_type.description!="Recreation"
      product_id=Building.where({:id=>params.fetch("query_building_id")}).first.products.first.id
      the_map_building.product_id = product_id
    end
  
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
