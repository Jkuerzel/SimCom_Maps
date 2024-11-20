namespace :import do
  desc "Import prices from CSV file into the prices table"
  task prices: :environment do
    require 'csv'

    file_path = Rails.root.join('db', 'data', 'current_prices.csv')
    
    unless File.exist?(file_path)
      puts "File not found: #{file_path}"
      next
    end

    # Clear the current entries in the Price table
    Price.delete_all

    CSV.foreach(file_path, headers: true) do |row|
      Price.create!(
        resource_id: row['resource_id'],
        quality_level: row['quality_level'],
        price: row['price']
      )
    end

    puts "Prices imported successfully from #{file_path}"
  end
end
