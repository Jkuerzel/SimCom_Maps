namespace :import do
  desc "Import required inputs data from CSV to Resourcedependency model"
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
      input_id = row["input_id"]
      quantity_required = row["quantity_required"]

      # Initialize a new Resourcedependency instance
      dependency = Resourcedependency.new(
        product_id: product_id,
        input_id: input_id,
        quantity_required: quantity_required
      )

      # Save without validations
      if dependency.save(validate: false)
        puts "Successfully imported Resourcedependency: Product ID #{product_id}, Input ID #{input_id}"
      else
        puts "Failed to save Resourcedependency for Product ID #{product_id} and Input ID #{input_id}"
      end
    end

    puts "Resourcedependency data import completed!"
  end
end
