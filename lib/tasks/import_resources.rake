namespace :import do
  desc "Import resources data from CSV to Resource model"
  task resources: :environment do
    require 'csv'

    # Define the path to the CSV file
    csv_path = Rails.root.join('db', 'data', 'resources.csv')

    # Check if the file exists
    unless File.exist?(csv_path)
      puts "File not found: #{csv_path}"
      exit
    end

    # Import each row from the CSV
    CSV.foreach(csv_path, headers: true) do |row|
      # Convert row to a hash with symbolized keys
      resource_attributes = row.to_hash.symbolize_keys
      
      # Create or update the Resource record
      Resource.find_or_create_by(id: resource_attributes[:id]) do |resource|
        resource.name = resource_attributes[:name]
        resource.transport_amount = resource_attributes[:transport_amount]
      end
    end

    puts "Resources data imported successfully!"
  end
end
