class ProductionrunsController < ApplicationController
  def index
    matching_productionruns = Productionrun.all

    @list_of_productionruns = matching_productionruns.order({ :created_at => :desc })

    render({ :template => "productionruns/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_productionruns = Productionrun.where({ :id => the_id })

    @the_productionrun = matching_productionruns.at(0)

    render({ :template => "productionruns/show" })
  end

  def create
    the_productionrun = Productionrun.new
    the_productionrun.product_id = params.fetch("query_product_id")
    the_productionrun.quality_level = params.fetch("query_quality_level")
    the_productionrun.production_time = params.fetch("query_production_time")
    the_productionrun.map_building_id = params.fetch("query_map_building_id")

    if the_productionrun.valid?
      the_productionrun.save
      redirect_to("/productionruns", { :notice => "Productionrun created successfully." })
    else
      redirect_to("/productionruns", { :alert => the_productionrun.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_productionrun = Productionrun.where({ :id => the_id }).at(0)

    the_productionrun.product_id = params.fetch("query_product_id")
    the_productionrun.quality_level = params.fetch("query_quality_level")
    the_productionrun.production_time = params.fetch("query_production_time")
    the_productionrun.map_building_id = params.fetch("query_map_building_id")

    if the_productionrun.valid?
      the_productionrun.save
      redirect_to("/productionruns/#{the_productionrun.id}", { :notice => "Productionrun updated successfully."} )
    else
      redirect_to("/productionruns/#{the_productionrun.id}", { :alert => the_productionrun.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_productionrun = Productionrun.where({ :id => the_id }).at(0)

    the_productionrun.destroy

    redirect_to("/productionruns", { :notice => "Productionrun deleted successfully."} )
  end
end
