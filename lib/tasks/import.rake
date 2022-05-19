require 'roo'
require "uri"
require "json"
require "net/http"
    
# url = URI("https://#{ShopifyAPI::Context.api_key}:#{ShopifyAPI::Context.api_secret_key}@#{ShopifyAPI::Context.host_name}.myshopify.com/admin/api/#{ShopifyAPI::Context.api_version}/products.json")
url =  URI("https://afc7bf55fcb3c9b22271d9b856cfb7c3:94eac404e1b0b14313534f7b9979ef92@protonshub.myshopify.com/admin/api/2022-01/products.json")

#url = URI("https://{{api_key}}:{{api_password}}@{{store_name}}.myshopify.com/admin/api/{{api_version}}/products/{{product_id}}/metafields.json")
https = Net::HTTP.new(url.host, url.port)
https.use_ssl = true

request = Net::HTTP::Post.new(url)
request["Content-Type"] = "application/json"
request["x-shopify-access-token"]="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"

namespace :import do
  desc "Import data of watch from spreadsheet"
  task watch: :environment do
    puts 'Importing Data' # add this line
    data = Roo::Spreadsheet.open('lib/watch.xlsx') # open spreadsheet
    headers = data.row(1) # get header row
    data.each_with_index do |row, idx|
      next if idx == 0 # skip header
      user_data = Hash[[headers, row].transpose]
      if user_data["Product Name"]==nil
        break
      end
      request.body = JSON.dump({
        "product": {
          "title": "#{user_data["Product Name"]}",          
          "body_html": "<strong>#{user_data["Description"]}</strong>",
          "vendor": "#{user_data["Brand"]}",
          "product_type": "watches",
          "variants": [{
            "sku": "#{user_data["Reference-Number"]}",
            "inventory_quantity": "#{user_data["Quantity"]}",
            "tracked": "true"
          }]
        }
      })
      response = https.request(request)
      puts response.read_body
      product_id=JSON.parse(response.read_body)["product"]["id"]
      url_meta =  URI("https://afc7bf55fcb3c9b22271d9b856cfb7c3:94eac404e1b0b14313534f7b9979ef92@protonshub.myshopify.com/admin/api/2022-01/products/#{product_id}/metafields.json")
      https1 = Net::HTTP.new(url_meta.host, url_meta.port)
      https1.use_ssl = true
      request1 = Net::HTTP::Post.new(url_meta)
      request1["Content-Type"] = "application/json"
      request1["x-shopify-access-token"]="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"
      headers.each do |header|
        header1=header.strip.gsub(" ","_")
        request1.body = JSON.dump({
          "metafield": {
            "namespace": "watches",
            "key": "#{header1}",
            "value": "#{user_data[header].blank? ? "0" : user_data[header]}",
            "type": "single_line_text_field"
          }
        })
        response = https1.request(request1)
        puts response.read_body
      end
    end
  end
  desc "Import data of jwellery from spreadsheet"
  task jewellery: :environment do
    puts 'Importing Data' # add this line
    data = Roo::Spreadsheet.open('lib/jewellery.xlsx') # open spreadsheet
    headers = data.row(1) # get header row
    data.each_with_index do |row, idx|
      next if idx == 0 # skip header
      user_data = Hash[[headers, row].transpose]
      if user_data["Product Name"]==nil
        break
      end
      request.body = JSON.dump({
        "product": {
          "title": "#{user_data["Product Name"]}",          
          "body_html": "<strong>#{user_data["Description"]}</strong>",
          "vendor": "#{user_data["Brand"]}",
          "product_type": "jewelleries"
        }
      })
      response = https.request(request)
      puts response.read_body
      product_id=JSON.parse(response.read_body)["product"]["id"]
      url_meta =  URI("https://afc7bf55fcb3c9b22271d9b856cfb7c3:94eac404e1b0b14313534f7b9979ef92@protonshub.myshopify.com/admin/api/2022-01/products/#{product_id}/metafields.json")
      https1 = Net::HTTP.new(url_meta.host, url_meta.port)
      https1.use_ssl = true
      request1 = Net::HTTP::Post.new(url_meta)
      request1["Content-Type"] = "application/json"
      request1["x-shopify-access-token"]="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"
      headers.each do |header|
        header1=header.strip.gsub(" ","_")
        header1=header1.strip.gsub("-","_")
        request1.body = JSON.dump({
          "metafield": {
            "namespace": "jewelleries",
            "key": "#{header1}",
            "value": "#{user_data[header].blank? ? "0" : user_data[header]}",
            "type": "single_line_text_field"
          }
        })
        response = https1.request(request1)
        puts response.read_body
      end
    end
  end
end