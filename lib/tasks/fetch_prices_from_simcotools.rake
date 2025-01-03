namespace :prices do
  desc "Fetch market prices and import them into the database"
  
  task fetch_and_import: :environment do
    require 'httparty'

    # Define the API endpoint
    realm_id = 0
    url = "https://api.simcotools.com/v1/realms/#{realm_id}/market/prices"

    # Fetch data from the API
    response = HTTParty.get(url, headers: { "accept" => "application/json" }, verify: false)

    if response.code == 200
      puts "Response received: #{response.body}"
      prices = response.parsed_response["prices"]
      puts "Parsed prices: #{prices.inspect}"

      # Import prices directly into the database
      prices.each do |price|
        Price.create!(
          resource_id: price["resourceId"],
          quality_level: price["quality"],
          price: price["price"],
          created_at: Time.current
        )
      end

      puts "Prices imported successfully!"
    else
      puts "Error fetching prices. Status code: #{response.code}"
      puts "Response body: #{response.body}"
    end
  end
end
