class HomeController < ApplicationController
  def index

    @the_resource=Resource.where({:id=>10}).at(0)
    @the_building=Building.where({:id=>10}).at(0)

    render({:template=>"home_templates/index"})
  end
end
