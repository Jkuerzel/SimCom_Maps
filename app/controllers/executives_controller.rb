class ExecutivesController < ApplicationController
  def index
    matching_executives = Executive.all

    @list_of_executives = matching_executives.order({ :created_at => :desc })

    render({ :template => "executives/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_executives = Executive.where({ :id => the_id })

    @the_executive = matching_executives.at(0)

    render({ :template => "executives/show" })
  end

  def create
    the_executive = Executive.new
    the_executive.name = params.fetch("query_name")
    the_executive.map_id = params.fetch("query_map_id")
    the_executive.position = params.fetch("query_position")
    the_executive.operations_level = params.fetch("query_operations_level")
    the_executive.finance_level = params.fetch("query_finance_level")
    the_executive.marketing_level = params.fetch("query_marketing_level")
    the_executive.research_level = params.fetch("query_research_level")
    the_executive.salary = params.fetch("query_salary")

    if the_executive.valid?
      the_executive.save
      redirect_to("/executives", { :notice => "Executive created successfully." })
    else
      redirect_to("/executives", { :alert => the_executive.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_executive = Executive.where({ :id => the_id }).at(0)

    the_executive.name = params.fetch("query_name")
    the_executive.map_id = params.fetch("query_map_id")
    the_executive.position = params.fetch("query_position")
    the_executive.operations_level = params.fetch("query_operations_level")
    the_executive.finance_level = params.fetch("query_finance_level")
    the_executive.marketing_level = params.fetch("query_marketing_level")
    the_executive.research_level = params.fetch("query_research_level")
    the_executive.salary = params.fetch("query_salary")

    if the_executive.valid?
      the_executive.save
      redirect_to("/executives/#{the_executive.id}", { :notice => "Executive updated successfully."} )
    else
      redirect_to("/executives/#{the_executive.id}", { :alert => the_executive.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_executive = Executive.where({ :id => the_id }).at(0)

    the_executive.destroy

    redirect_to("/executives", { :notice => "Executive deleted successfully."} )
  end
end
