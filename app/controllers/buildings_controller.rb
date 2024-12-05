class BuildingsController < ApplicationController
  def index
    matching_buildings = Building.all

    @list_of_buildings = matching_buildings.order(:id)

    render({ :template => "buildings/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_buildings = Building.where({ :id => the_id })

    @the_building = matching_buildings.at(0)

    render({ :template => "buildings/show" })
  end

  def create
    the_building = Building.new
    the_building.name = params.fetch("query_name")
    the_building.wage_cost_per_hour = params.fetch("query_wage_cost_per_hour")
    the_building.construction_price = params.fetch("query_construction_price")
    the_building.description = params.fetch("query_description")
    the_building.map_buildings_count = params.fetch("query_map_buildings_count")

    if the_building.valid?
      the_building.save
      redirect_to("/buildings", { :notice => "Building created successfully." })
    else
      redirect_to("/buildings", { :alert => the_building.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_building = Building.where({ :id => the_id }).at(0)

    the_building.name = params.fetch("query_name")
    the_building.wage_cost_per_hour = params.fetch("query_wage_cost_per_hour")
    the_building.construction_price = params.fetch("query_construction_price")
    the_building.description = params.fetch("query_description")
    the_building.map_buildings_count = params.fetch("query_map_buildings_count")

    if the_building.valid?
      the_building.save
      redirect_to("/buildings/#{the_building.id}", { :notice => "Building updated successfully."} )
    else
      redirect_to("/buildings/#{the_building.id}", { :alert => the_building.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_building = Building.where({ :id => the_id }).at(0)

    the_building.destroy

    redirect_to("/buildings", { :notice => "Building deleted successfully."} )
  end
end
