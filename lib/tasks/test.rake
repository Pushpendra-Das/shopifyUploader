require 'rubyXL/convenience_methods'
require "uri"
require "json"
require "net/http"
require 'pry'


namespace :test do
  desc "update Watches" ############################################### Update Watches 
  task watch: :environment do
    data = Roo::Spreadsheet.open('lib/watch.xlsx') # open spreadsheet
    headers = data.row(1) # get header row'
    data.each_with_index do |row, idx|
      next if idx == 0 # skip header
      user_data = Hash[[headers, row].transpose]
      if user_data["Product Name"]==nil
        break
      end
      ############################################################## Update Normal Field Of Watch
      url = URI("https://afc7bf55fcb3c9b22271d9b856cfb7c3:94eac404e1b0b14313534f7b9979ef92@protonshub.myshopify.com/admin/api/2022-01/products/#{user_data["product_id"]}.json")
      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true

      request = Net::HTTP::Put.new(url)
      request["Content-Type"] = "application/json"
      request["x-shopify-access-token"]="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"


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
      ############################################################## Update Metafields Of Watch
      url_meta = URI("https://afc7bf55fcb3c9b22271d9b856cfb7c3:94eac404e1b0b14313534f7b9979ef92@protonshub.myshopify.com/admin/api/2022-01/products/#{user_data["product_id"]}/metafields/#{user_data["metafield_id"]}.json")
      https1 = Net::HTTP.new(url_meta.host, url_meta.port)
      https1.use_ssl = true
      request1 = Net::HTTP::Put.new(url_meta)
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

  desc "Update Jewelleries"   ###############################################  Update Jewelleries
  task watch: :environment do
    data = Roo::Spreadsheet.open('lib/jewellery.xlsx') # open spreadsheet
    headers = data.row(1) # get header row'
    data.each_with_index do |row, idx|
      next if idx == 0 # skip header
      user_data = Hash[[headers, row].transpose]
      if user_data["Product Name"]==nil
        break
      end
      ############################################################## Update Manditory Field Of Jewellery
      url = URI("https://afc7bf55fcb3c9b22271d9b856cfb7c3:94eac404e1b0b14313534f7b9979ef92@protonshub.myshopify.com/admin/api/2022-01/products/#{user_data["product_id"]}.json")
      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true

      request = Net::HTTP::Put.new(url)
      request["Content-Type"] = "application/json"

      request.body = JSON.dump({
        "product": {
          "title": "#{user_data["Product Name"]}",          
          "body_html": "<strong>#{user_data["Description"]}</strong>",
          "vendor": "#{user_data["Brand"]}",
          "product_type": "jewelleries",
          "variants": [
            {
              "option1": "#{user_data["Metal"]}"
            },
            {
              "option1": "#{user_data["Also Available In"]}"
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
      ############################################################## Update Metafields Of Jewellery
      url_meta = URI("https://afc7bf55fcb3c9b22271d9b856cfb7c3:94eac404e1b0b14313534f7b9979ef92@protonshub.myshopify.com/admin/api/2022-01/products/#{product_id}/metafields/#{metafield_id}.json")
      https1 = Net::HTTP.new(url_meta.host, url_meta.port)
      https1.use_ssl = true
      request1 = Net::HTTP::Put.new(url_meta)
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

end