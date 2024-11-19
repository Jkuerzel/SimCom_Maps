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
    the_map_building.map_id = params[:map_id]
    the_map_building.building_id = params.fetch("query_building_id")
    the_map_building.position_id = params.fetch("query_position_id")
    the_map_building.level = params.fetch("query_level")
    the_map_building.quality_level = 0
    the_map_building.production_time = 24

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

    the_map_building.map_id = params.fetch("query_map_id")
    the_map_building.building_id = params.fetch("query_building_id")
    the_map_building.position_id = params.fetch("query_position_id")
    the_map_building.level = params.fetch("query_level")
    the_map_building.production_time = params.fetch("query_production_time")
    the_map_building.quality_level = params.fetch("query_quality_level")
    the_map_building.product_id = params.fetch("query_product_id")

    if the_map_building.valid?
      the_map_building.save
      redirect_to("/map_buildings/#{the_map_building.id}", { :notice => "Map building updated successfully."} )
    else
      redirect_to("/map_buildings/#{the_map_building.id}", { :alert => the_map_building.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_map_building = MapBuilding.where({ :id => the_id }).at(0)

    the_map_building.destroy

    redirect_to("/map_buildings", { :notice => "Map building deleted successfully."} )
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
  
    the_map_building.building_id = params.fetch("query_building_id")
    product_id=Building.where({:id=>params.fetch("query_building_id")}).first.products.first.id
    the_map_building.product_id = product_id
  
    if the_map_building.valid?
      the_map_building.save
      redirect_to("/map_buildings/#{the_map_building.id}", { :notice => "Map building updated successfully."} )
    else
      redirect_to("/map_buildings/#{the_map_building.id}", { :alert => the_map_building.errors.full_messages.to_sentence })
    end
  end
  
end
