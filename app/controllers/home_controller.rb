class HomeController < ApplicationController
  def index

    render({:template=>"home_templates/index"})
  end
  def login

    @list_of_maps=Map.all.order({:operating_profit=>:desc})
    @top10_maps = @list_of_maps.first(10)
    render({:template=>"home_templates/login"})
  end
end
