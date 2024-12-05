class AddOperatingProfitAndTotalRevenueToMaps < ActiveRecord::Migration[6.0]
  def change
    add_column :maps, :operating_profit, :decimal, precision: 15, scale: 2, default: 0.0
    add_column :maps, :total_revenue, :decimal, precision: 15, scale: 2, default: 0.0
  end
end
