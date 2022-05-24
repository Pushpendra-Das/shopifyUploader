require "uri"
require "json"
require "net/http"
require 'pry'
require 'roo'

namespace :update do
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
            "price": "#{user_data["Price"]}",
            "sku": "#{user_data["Reference-Number"]}",
            "inventory_quantity": "#{user_data["Quantity"]}"
          }]
        }
      })
      response = https.request(request)
      puts response.read_body
      header_counter=0
      ############################################################## Update Metafields Of Watch
      headers.each do |header|
        if header_counter==28   #### We stoped it after 28 column because after that all are product and meta id's 
          break
        end
        header1=header.strip.gsub(" ","_")
        header1=header1.strip.gsub("-","_")
        url_meta = URI("https://afc7bf55fcb3c9b22271d9b856cfb7c3:94eac404e1b0b14313534f7b9979ef92@protonshub.myshopify.com/admin/api/2022-01/products/#{user_data["product_id"]}/metafields/#{user_data["metafield_#{header1}_id"]}.json")
        https1 = Net::HTTP.new(url_meta.host, url_meta.port)
        https1.use_ssl = true
        request1 = Net::HTTP::Put.new(url_meta)
        request1["Content-Type"] = "application/json"
        request1["x-shopify-access-token"]="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"
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
        header_counter+=1
      end
    
    end
  end
########################################################################################################
  desc "Update Jewelleries"   ###############################################  Update Jewelleries
  task jewellery: :environment do
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
      request["x-shopify-access-token"]="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"
      request.body = JSON.dump({
        "product": {
          "title": "#{user_data["Product Name"]}",          
          "body_html": "<strong>#{user_data["Description"]}</strong>",
          "vendor": "#{user_data["Brand"]}",
          "product_type": "jewelleries",
          "variants": [
            {
              "price": "#{user_data["Price"]}",
              "sku": "#{user_data["Reference-Number"]}",
              "inventory_quantity": "#{user_data["Quantity"]}",
              "option1": "#{user_data["Metal"]}"
            },
            {
              "price": "#{user_data["Price"]}",
              "sku": "#{user_data["Reference-Number"]}",
              "inventory_quantity": "#{user_data["Quantity"]}",
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
      header_counter=0
      ############################################################## Update Metafields Of Jewellery
      headers.each do |header|
        if header_counter==24 #### We stoped it after 24 column because after that all are product and meta id's
          break
        end
        header1=header.strip.gsub(" ","_")
        header1=header1.strip.gsub("-","_")
        url_meta = URI("https://afc7bf55fcb3c9b22271d9b856cfb7c3:94eac404e1b0b14313534f7b9979ef92@protonshub.myshopify.com/admin/api/2022-01/products/#{user_data["product_id"]}/metafields/#{user_data["metafield_#{header1}_id"]}.json")
        https1 = Net::HTTP.new(url_meta.host, url_meta.port)
        https1.use_ssl = true
        request1 = Net::HTTP::Put.new(url_meta)
        request1["Content-Type"] = "application/json"
        request1["x-shopify-access-token"]="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"
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
        header_counter+=1
      end
    end
  end

end