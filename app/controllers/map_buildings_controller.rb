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
end
