class UsersController < ApplicationController
  def index
    matching_users = User.all

    @list_of_users = matching_users.order({ :created_at => :desc })

    render({ :template => "users/index" })
  end

  def my_profile

    @the_user = current_user # Use current_user provided by Devise

    render({ :template => "devise/user/my_profile" })
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

  def update_name_email
    the_user = current_user
    the_user.username = params.fetch("query_username")
    the_user.email = params.fetch("query_email")

    if the_user.valid?
      the_user.save
      redirect_to("/users/my_profile", { :notice => "User updated successfully."} )
    else
      redirect_to("/users/my_profile", { :alert => the_user.errors.full_messages.to_sentence })
    end
  end

  def update_password
    the_user = current_user
  
    # Verify the current password
    if the_user.valid_password?(params[:current_password])
      # Update the password
      the_user.password = params[:password]
      the_user.password_confirmation = params[:password_confirmation]
  
      if the_user.save
        bypass_sign_in(the_user) # Keep the user signed in
        redirect_to("/users/my_profile", notice: "Password updated successfully.")
      else
        redirect_to("/users/my_profile", alert: the_user.errors.full_messages.to_sentence)
      end
    else
      redirect_to("/users/my_profile", alert: "Current password is incorrect.")
    end
  end

end
