namespace :prices do
  desc "Fetch market prices and import them into the database"
  
  task fetch_and_import: :environment do
    require 'httparty'

    # Define the API endpoint
    realm_id = 0 # Update the realm_id as needed
    url = "https://api.simcotools.app/v1/realms/#{realm_id}/market/prices"

    # Fetch data from the API
    response = HTTParty.get(url, verify: false)

    if response.code == 200
      prices = response.parsed_response["prices"]

      # Import prices directly into the database
      prices.each do |price|
        Price.create!(
          resource_id: price["resourceId"],
          quality_level: price["quality"],
          price: price["price"],
          created_at: Time.current # Set created_at to current time
        )
      end

      puts "Prices imported successfully!"
    else
      puts "Error fetching prices. Status code: #{response.code}"
    end
  end
end
