class UsersController < ApplicationController
  def index
    matching_users = User.all

    @list_of_users = matching_users.order({ :created_at => :desc })

    render({ :template => "users/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_users = User.where({ :id => the_id })

    @the_user = matching_users.at(0)

    render({ :template => "users/show" })
  end

  def create
    the_user = User.new
    the_user.username = params.fetch("query_username")
    the_user.password = params.fetch("query_password")
    the_user.email = params.fetch("query_email")
    the_user.comments_count = params.fetch("query_comments_count", 0) # Default to 0 if not provided
    the_user.maps_count = params.fetch("query_maps_count", 0)        # Default to 0 if not provided
    the_user.likes_count = params.fetch("query_likes_count", 0)      # Default to 0 if not provided
  
    if the_user.valid?
      the_user.save
      redirect_to("/users", { notice: "User created successfully." })
    else
      redirect_to("/users", { alert: the_user.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_user = User.where({ :id => the_id }).at(0)

    the_user.username = params.fetch("query_username")
    the_user.password = params.fetch("query_password")
    the_user.email = params.fetch("query_email")
    the_user.comments_count = params.fetch("query_comments_count")
    the_user.maps_count = params.fetch("query_maps_count")
    the_user.likes_count = params.fetch("query_likes_count")

    if the_user.valid?
      the_user.save
      redirect_to("/users/#{the_user.id}", { :notice => "User updated successfully."} )
    else
      redirect_to("/users/#{the_user.id}", { :alert => the_user.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_user = User.where({ :id => the_id }).at(0)

    the_user.destroy

    redirect_to("/users", { :notice => "User deleted successfully."} )
  end
end
