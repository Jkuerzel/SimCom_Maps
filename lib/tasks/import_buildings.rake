namespace :import do
  desc "Reset and import buildings data from CSV to Building model"
  task buildings: :environment do
    require 'csv'

    # Define the path to the CSV file
    csv_path = Rails.root.join('db', 'data', 'buildings.csv')

    # Check if the file exists
    unless File.exist?(csv_path)
      puts "File not found: #{csv_path}"
      exit
    end

    # Destroy all existing Building records
    Building.delete_all
    puts "All existing Building records deleted."

    # Import each row from the CSV
    CSV.foreach(csv_path, headers: true, col_sep: ';') do |row|
      building_attributes = {
        id: row["id"],
        name: row["name"],
        wage_cost_per_hour: row["wage_cost_per_hour"],
        construction_price: row["construction_price"],
        description: row["description"],
        image_link: row["image_link"],
        robot_demand: row["robot_demand"]
      }

      # Directly create Building record without validations
      building = Building.new(building_attributes)
      if building.save(validate: false)
        puts "Successfully imported Building ID #{building.id} - #{building.name}"
      else
        puts "Failed to import Building ID #{building.id} - #{building.name}"
      end
    end

    puts "Buildings data import completed!"
  end
end
