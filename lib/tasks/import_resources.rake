namespace :import do
  desc "Reset and import resources data from CSV to Resource model"
  task resources: :environment do
    require 'csv'

    # Define the path to the CSV file
    csv_path = Rails.root.join('db', 'data', 'resources.csv')

    # Check if the file exists
    unless File.exist?(csv_path)
      puts "File not found: #{csv_path}"
      exit
    end

    # Destroy all existing Resource records
    Resource.delete_all
    puts "All existing Resource records deleted."

    # Import each row from the CSV
    CSV.foreach(csv_path, headers: true, col_sep: ';') do |row|
      resource_attributes = {
        id: row["id"],
        name: row["name"],
        transport_amount: row["transport_amount"],
        building_id: row["building_id"],
        units_per_hour: row["units_per_hour"],
        image_link: row["image_link"]
      }

      # Directly create Resource record without validations
      resource = Resource.new(resource_attributes)
      if resource.save(validate: false)
        puts "Successfully imported Resource ID #{resource.id} - #{resource.name}"
      else
        puts "Failed to import Resource ID #{resource.id} - #{resource.name}"
      end
    end

    puts "Resources data import completed!"
  end
end
