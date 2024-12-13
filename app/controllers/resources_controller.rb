class ResourcesController < ApplicationController

  include ActionView::Helpers::NumberHelper
  def index
    matching_resources = Resource.all

    @list_of_resources = matching_resources.order(:id)

    render({ :template => "resources/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_resources = Resource.where({ :id => the_id })

    @the_resource = matching_resources.at(0)

    @prices_by_quality = (0..12).each_with_object({}) do |quality, hash|
      price = @the_resource.price_for_quality(quality) # Fetch the price
      if price.present?
        rounded_price = smart_round(price) # Apply smart rounding
        hash[quality] = rounded_price # Keep prices as numbers
      end
    end

    render({ :template => "resources/show" })
  end

  def smart_round(number)
    number = number.to_f
    return number.to_i if number == number.to_i
    significant_digits = (Math.log10(1.0 / number.abs).ceil + 2) if number != 0
    number.round(significant_digits || 0)
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
