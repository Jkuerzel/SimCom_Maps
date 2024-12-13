class ResourcesController < ApplicationController
  def index
    matching_resources = Resource.all

    @list_of_resources = matching_resources.order(:id)

    render({ :template => "resources/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_resources = Resource.where({ :id => the_id })

    @the_resource = matching_resources.at(0)

    render({ :template => "resources/show" })
  end

  def create
    the_resource = Resource.new
    the_resource.name = params.fetch("query_name")
    the_resource.transport_amount = params.fetch("query_transport_amount")
    the_resource.building_id = params.fetch("query_building_id")
    the_resource.production_time_per_unit = params.fetch("query_production_time_per_unit")

    if the_resource.valid?
      the_resource.save
      redirect_to("/resources", { :notice => "Resource created successfully." })
    else
      redirect_to("/resources", { :alert => the_resource.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_resource = Resource.where({ :id => the_id }).at(0)

    the_resource.name = params.fetch("query_name")
    the_resource.transport_amount = params.fetch("query_transport_amount")
    the_resource.building_id = params.fetch("query_building_id")
    the_resource.production_time_per_unit = params.fetch("query_production_time_per_unit")

    if the_resource.valid?
      the_resource.save
      redirect_to("/resources/#{the_resource.id}", { :notice => "Resource updated successfully."} )
    else
      redirect_to("/resources/#{the_resource.id}", { :alert => the_resource.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_resource = Resource.where({ :id => the_id }).at(0)

    the_resource.destroy

    redirect_to("/resources", { :notice => "Resource deleted successfully."} )
  end

end
