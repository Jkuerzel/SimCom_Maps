class HomeController < ApplicationController
  def index

    @the_resource=Resource.where({:id=>10}).at(0)
    @the_building=Building.where({:id=>10}).at(0)

    render({:template=>"home_templates/index"})
  end
  def login

    @the_resource=Resource.where({:id=>10}).at(0)
    @the_building=Building.where({:id=>10}).at(0)
    @list_of_maps=Map.all.order({:operating_profit=>:desc})
    @top10_maps = @list_of_maps.first(10)
    render({:template=>"home_templates/login"})
  end
end
