namespace :import do
  desc "Import required inputs data from CSV to RequiredInput model"
  task required_inputs: :environment do
    require 'csv'

    # Define the path to the CSV file
    csv_path = Rails.root.join('db', 'data', 'resources_inputs.csv')

    # Check if the file exists
    unless File.exist?(csv_path)
      puts "File not found: #{csv_path}"
      exit
    end

    # Import each row from the CSV
    CSV.foreach(csv_path, headers: true) do |row|
      product_id = row["product_id"]
      resource_id = row["resource_id"]
      quantity_required = row["quantity_required"]

      # Directly create RequiredInput record without verifying Product existence
      if Resource.exists?(id: resource_id)
        RequiredInput.create!(
          product_id: product_id,
          resource_id: resource_id,
          quantity_required: quantity_required
        )
        puts "Successfully imported RequiredInput: Product ID #{product_id}, Resource ID #{resource_id}"
      else
        puts "Skipping row with non-existent resource_id: #{resource_id}"
      end
    end

    puts "Required inputs data import completed!"
  end
end
