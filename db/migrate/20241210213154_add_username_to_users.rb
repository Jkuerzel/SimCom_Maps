class AddUsernameToUsers < ActiveRecord::Migration[7.0]
  def change
    # Add the username column without the unique index
    add_column :users, :username, :string, default: nil

    # Backfill usernames with unique values
    User.reset_column_information
    User.find_each do |user|
      user.update_column(:username, "user_#{user.id}") # Assign unique default usernames
    end

    # Add unique index after backfilling
    change_column_default :users, :username, "default_user"
    add_index :users, :username, unique: true
  end
end
