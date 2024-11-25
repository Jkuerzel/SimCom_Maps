Rails.application.routes.draw do


  #------------------------------

  # Routes for the Executive resource:

  # CREATE
  post("/insert_executive", { :controller => "executives", :action => "create" })
          
  # READ
  get("/executives", { :controller => "executives", :action => "index" })
  
  get("/executives/:path_id", { :controller => "executives", :action => "show" })
  
  # UPDATE
  
  post("/modify_executive/:path_id", { :controller => "executives", :action => "update" })
  
  # DELETE
  get("/delete_executive/:path_id", { :controller => "executives", :action => "destroy" })

  #------------------------------

  # Routes for the Map building resource:

  # CREATE

  post("/insert_map_building", { :controller => "map_buildings", :action => "create" })
          
  # READ
  get("/map_buildings", { :controller => "map_buildings", :action => "index" })
  
  get("/map_buildings/:path_id", { :controller => "map_buildings", :action => "show" })
  
  # UPDATE
  
  post("/modify_map_building/:path_id", { :controller => "map_buildings", :action => "update" })
  post("/modify_map_building/:path_id/level", { :controller => "map_buildings", :action => "update_level" })
  post("/modify_map_building/:path_id/type", { :controller => "map_buildings", :action => "update_type" })
  post("/modify_map_building/:path_id/product", { :controller => "map_buildings", :action => "update_product" })
  post("/modify_map_building/:path_id/quality_level", { :controller => "map_buildings", :action => "update_quality" })

  patch("/modify_map_building/increment_level/:path_id", { controller: "map_buildings", action: "increment_level" })
  patch("/modify_map_building/decrement_level/:path_id", { controller: "map_buildings", action: "decrement_level" })
  patch("/modify_map_building/increment_quality/:path_id", { controller: "map_buildings", action: "increment_quality" })
  patch("/modify_map_building/decrement_quality/:path_id", { controller: "map_buildings", action: "decrement_quality" })

  
  # DELETE
  get("/delete_map_building/:map_id/:map_building_id", { :controller => "map_buildings", :action => "destroy" })

  #------------------------------

  # Routes for the Map resource:

  # CREATE
  post("/insert_map", { :controller => "maps", :action => "create" })     
  # READ
  get("/maps", { :controller => "maps", :action => "index" })
  get("/maps/:path_id", { :controller => "maps", :action => "show" })
  get("/maps/:path_id/new_building/:position_path", { :controller => "maps", :action => "new_building" })
  # UPDATE
  post("/modify_map/:path_id", { :controller => "maps", :action => "update" })
  # DELETE
  get("/delete_map/:path_id", { :controller => "maps", :action => "destroy" })

  #------------------------------

  # Routes for the Like resource:

  # CREATE
  post("/insert_like", { :controller => "likes", :action => "create" })
          
  # READ
  get("/likes", { :controller => "likes", :action => "index" })
  
  get("/likes/:path_id", { :controller => "likes", :action => "show" })
  
  # UPDATE
  
  post("/modify_like/:path_id", { :controller => "likes", :action => "update" })
  
  # DELETE
  get("/delete_like/:path_id", { :controller => "likes", :action => "destroy" })

  #------------------------------

  # Routes for the Comment resource:

  # CREATE
  post("/insert_comment", { :controller => "comments", :action => "create" })
          
  # READ
  get("/comments", { :controller => "comments", :action => "index" })
  
  get("/comments/:path_id", { :controller => "comments", :action => "show" })
  
  # UPDATE
  
  post("/modify_comment/:path_id", { :controller => "comments", :action => "update" })
  
  # DELETE
  get("/delete_comment/:path_id", { :controller => "comments", :action => "destroy" })

  #------------------------------

  # Routes for the Price resource:

  # CREATE
  post("/insert_price", { :controller => "prices", :action => "create" })
          
  # READ
  get("/prices", { :controller => "prices", :action => "index" })
  
  get("/prices/:path_id", { :controller => "prices", :action => "show" })
  
  # UPDATE
  
  post("/modify_price/:path_id", { :controller => "prices", :action => "update" })
  
  # DELETE
  get("/delete_price/:path_id", { :controller => "prices", :action => "destroy" })

  #------------------------------

  # Routes for the Resourcedependency resource:

  # CREATE
  post("/insert_resourcedependency", { :controller => "resourcedependencies", :action => "create" })
          
  # READ
  get("/resourcedependencies", { :controller => "resourcedependencies", :action => "index" })
  
  get("/resourcedependencies/:path_id", { :controller => "resourcedependencies", :action => "show" })
  
  # UPDATE
  
  post("/modify_resourcedependency/:path_id", { :controller => "resourcedependencies", :action => "update" })
  
  # DELETE
  get("/delete_resourcedependency/:path_id", { :controller => "resourcedependencies", :action => "destroy" })

  #------------------------------

  # Routes for the Resource resource:

  # CREATE
  post("/insert_resource", { :controller => "resources", :action => "create" })
          
  # READ
  get("/resources", { :controller => "resources", :action => "index" })
  
  get("/resources/:path_id", { :controller => "resources", :action => "show" })
  
  # UPDATE
  
  post("/modify_resource/:path_id", { :controller => "resources", :action => "update" })
  
  # DELETE
  get("/delete_resource/:path_id", { :controller => "resources", :action => "destroy" })

  #------------------------------

  # Routes for the Building resource:

  # CREATE
  post("/insert_building", { :controller => "buildings", :action => "create" })
          
  # READ
  get("/buildings", { :controller => "buildings", :action => "index" })
  
  get("/buildings/:path_id", { :controller => "buildings", :action => "show" })
  
  # UPDATE
  
  post("/modify_building/:path_id", { :controller => "buildings", :action => "update" })
  
  # DELETE
  get("/delete_building/:path_id", { :controller => "buildings", :action => "destroy" })

  #------------------------------

  devise_for :users
  root to: "home#login"


  
end
