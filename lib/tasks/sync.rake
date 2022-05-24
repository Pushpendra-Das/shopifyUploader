require "uri"
require "json"
require "net/http"
require 'roo'

namespace :sync do
  desc "Sync Both watches and jewelleries in inventory"
  task products: :environment do
    data = Roo::Spreadsheet.open('lib/watch.xlsx') # open spreadsheet
    headers = data.row(1) # get header row'
    data.each_with_index do |row, idx|
      next if idx == 0 # skip header
      user_data = Hash[[headers, row].transpose]
      if user_data["Product Name"]==nil
        break
      end
      url = URI("https://afc7bf55fcb3c9b22271d9b856cfb7c3:94eac404e1b0b14313534f7b9979ef92@protonshub.myshopify.com/admin/api/2022-01/products/#{user_data["product_id"]}.json")
      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true
      request = Net::HTTP::Put.new(url)
      request["Content-Type"] = "application/json"
      request["x-shopify-access-token"]="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"
      request.body = JSON.dump({
        "product": {
          "variants": [
            {
              "price": "#{user_data["Price"]}",
              "sku": "#{user_data["Reference Number"]}",
              "inventory_quantity": "#{user_data["Quantity"]}",
              "tracked": true
            }]
        }
      })
      response = https.request(request)
      puts response.read_body
    end
    data = Roo::Spreadsheet.open('lib/jewellery.xlsx') # open spreadsheet
    headers = data.row(1) # get header row'
    data.each_with_index do |row, idx|
      next if idx == 0 # skip header
      user_data = Hash[[headers, row].transpose]
      if user_data["Product Name"]==nil
        break
      end
      url = URI("https://afc7bf55fcb3c9b22271d9b856cfb7c3:94eac404e1b0b14313534f7b9979ef92@protonshub.myshopify.com/admin/api/2022-01/products/#{user_data["product_id"]}.json")
      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true
      request = Net::HTTP::Put.new(url)
      request["Content-Type"] = "application/json"
      request["x-shopify-access-token"]="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"
      request.body = JSON.dump({
        "product": {
          "variants": [
            {
              "price": "#{user_data["Price"]}",
              "sku": "#{user_data["Reference-Number"]}",
              "inventory_quantity": "#{user_data["Quantity"]}",
              "option1": "#{user_data["Metal"]}",
              "tracked": true
            },
            {
              "price": "#{user_data["Price"]}",
              "sku": "#{user_data["Reference-Number"]}",
              "inventory_quantity": "#{user_data["Quantity"]}",
              "option1": "#{user_data["Also Available In"]}",
              "tracked": true
            }
          ],
          "options": [
            {
              "name": "Metal",
              "values": [
                  "#{user_data["Metal"]}",
                  "#{user_data["Also Available In"]}"            
                ]
            }
          ]
        }
      })
      response = https.request(request)
      puts response.read_body
    end
  end
end
