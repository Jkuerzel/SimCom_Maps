namespace :import do
  desc "Import building data from CSV to Building model"
  task buildings: :environment do
    require 'csv'

    # Define the path to the CSV file
    csv_path = Rails.root.join('db', 'data', 'buildings.csv')

    # Check if the file exists
    unless File.exist?(csv_path)
      puts "File not found: #{csv_path}"
      exit
    end

    # Import each row from the CSV
    CSV.foreach(csv_path, headers: true) do |row|
      # Create a new Building record with the row data
      Building.create!(row.to_hash)
    end

    puts "Buildings data imported successfully!"
  end
end
