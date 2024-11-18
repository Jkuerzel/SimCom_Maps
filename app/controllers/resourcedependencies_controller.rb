class ResourcedependenciesController < ApplicationController
  def index
    matching_resourcedependencies = Resourcedependency.all

    @list_of_resourcedependencies = matching_resourcedependencies.order({ :created_at => :desc })

    render({ :template => "resourcedependencies/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_resourcedependencies = Resourcedependency.where({ :id => the_id })

    @the_resourcedependency = matching_resourcedependencies.at(0)

    render({ :template => "resourcedependencies/show" })
  end

  def create
    the_resourcedependency = Resourcedependency.new
    the_resourcedependency.product_id = params.fetch("query_product_id")
    the_resourcedependency.input_id = params.fetch("query_input_id")
    the_resourcedependency.quantity_required = params.fetch("query_quantity_required")

    if the_resourcedependency.valid?
      the_resourcedependency.save
      redirect_to("/resourcedependencies", { :notice => "Resourcedependency created successfully." })
    else
      redirect_to("/resourcedependencies", { :alert => the_resourcedependency.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_resourcedependency = Resourcedependency.where({ :id => the_id }).at(0)

    the_resourcedependency.product_id = params.fetch("query_product_id")
    the_resourcedependency.input_id = params.fetch("query_input_id")
    the_resourcedependency.quantity_required = params.fetch("query_quantity_required")

    if the_resourcedependency.valid?
      the_resourcedependency.save
      redirect_to("/resourcedependencies/#{the_resourcedependency.id}", { :notice => "Resourcedependency updated successfully."} )
    else
      redirect_to("/resourcedependencies/#{the_resourcedependency.id}", { :alert => the_resourcedependency.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_resourcedependency = Resourcedependency.where({ :id => the_id }).at(0)

    the_resourcedependency.destroy

    redirect_to("/resourcedependencies", { :notice => "Resourcedependency deleted successfully."} )
  end
end
