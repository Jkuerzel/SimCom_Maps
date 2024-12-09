class MapsController < ApplicationController
  def index
    matching_maps = Map.all

    @list_of_maps = matching_maps.order({ :created_at => :desc })

    redirect_to("/")
    return
    #render({ :template => "maps/index" })

  end

  def show
    the_id = params.fetch("path_id")

    matching_maps = Map.where({ :id => the_id })

    @the_map = matching_maps.at(0)


    matching_buildings=MapBuilding.where({:map_id=>the_id})
    @total_asset_value = matching_buildings.joins(:building_type).sum("buildings.construction_price")

    production_results = @the_map.production
    @ledger = production_results[:ledger]
    @income_statement = production_results[:income_statement]

    @the_map.operating_profit=@income_statement[:operating_income]
    @the_map.total_revenue=@income_statement[:total_revenue]
    @the_map.save
    render({ :template => "maps/show" })
  end

  def create
    the_map = Map.new
    the_map.owner_id = current_user.id
    the_map.name = params.fetch("query_name")
    the_map.map_buildings_count=0
    the_map.executives_count=0
    the_map.bonus=params.fetch("query_bonus")
    
    if the_map.valid?
      the_map.save
      redirect_to("/maps", { :notice => "Map created successfully." })
    else
      redirect_to("/maps", { :alert => the_map.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_map = Map.where({ :id => the_id }).at(0)

    
    the_map.name = params.fetch("query_name")
    the_map.bonus = params.fetch("query_bonus")

    if the_map.valid?
      the_map.save
      

      redirect_to("/maps/#{the_map.id}", { :notice => "Map updated successfully."} )
    else
      redirect_to("/maps/#{the_map.id}", { :alert => the_map.errors.full_messages.to_sentence })
    end
  end

  def new_building
    the_id = params.fetch("path_id")
    @the_position_id=params.fetch("position_path")
    @the_map = Map.where({ :id => the_id }).at(0)

    render({ :template => "maps/new" })
  end

  def destroy
    the_id = params.fetch("path_id")
    the_map = Map.where({ :id => the_id }).at(0)

    the_map.destroy

    redirect_to("/maps", { :notice => "Map deleted successfully."} )
  end
end
