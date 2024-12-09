class AddRobotDemandToBuildings < ActiveRecord::Migration[6.1]
  def change
    add_column :buildings, :robot_demand, :integer, default: 1
  end
end
