class PricesController < ApplicationController
  def index
    matching_prices = Price.all

    @list_of_prices = matching_prices.order({ :created_at => :desc })

    render({ :template => "prices/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_prices = Price.where({ :id => the_id })

    @the_price = matching_prices.at(0)

    render({ :template => "prices/show" })
  end

  def create
    the_price = Price.new
    the_price.resource_id = params.fetch("query_resource_id")
    the_price.quality_level = params.fetch("query_quality_level")
    the_price.price = params.fetch("query_price")

    if the_price.valid?
      the_price.save
      redirect_to("/prices", { :notice => "Price created successfully." })
    else
      redirect_to("/prices", { :alert => the_price.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_price = Price.where({ :id => the_id }).at(0)

    the_price.resource_id = params.fetch("query_resource_id")
    the_price.quality_level = params.fetch("query_quality_level")
    the_price.price = params.fetch("query_price")

    if the_price.valid?
      the_price.save
      redirect_to("/prices/#{the_price.id}", { :notice => "Price updated successfully."} )
    else
      redirect_to("/prices/#{the_price.id}", { :alert => the_price.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_price = Price.where({ :id => the_id }).at(0)

    the_price.destroy

    redirect_to("/prices", { :notice => "Price deleted successfully."} )
  end
end
