require 'roo' ############## Gem used to read as hash from xlsx
require "uri"
require "json"
require "net/http"
require 'rubyXL/convenience_methods' ############## Gem used to write in xlsx
    
# url = URI("https://#{ShopifyAPI::Context.api_key}:#{ShopifyAPI::Context.api_secret_key}@#{ShopifyAPI::Context.host_name}.myshopify.com/admin/api/#{ShopifyAPI::Context.api_version}/products.json")
url =  URI("https://afc7bf55fcb3c9b22271d9b856cfb7c3:94eac404e1b0b14313534f7b9979ef92@protonshub.myshopify.com/admin/api/2022-01/products.json")


https = Net::HTTP.new(url.host, url.port)
https.use_ssl = true

request = Net::HTTP::Post.new(url)
request["Content-Type"] = "application/json"
request["x-shopify-access-token"]="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"

namespace :upload do
  desc "Upload data of watch from spreadsheet" ############################# Upload Watch
  task watch: :environment do
    puts 'Uploading Data' # add this line
    data = Roo::Spreadsheet.open('lib/watch.xlsx') # open spreadsheet
    headers = data.row(1) # get header row'
    data.each_with_index do |row, idx|
      next if idx == 0 # skip header
      user_data = Hash[[headers, row].transpose]
      if user_data["Product Name"]==nil
        break
      end
      ############################################# Normal Data Of Watch to Upload
      request.body = JSON.dump({
        "product": {
          "title": "#{user_data["Product Name"]}",          
          "body_html": "<strong>#{user_data["Description"]}</strong>",
          "vendor": "#{user_data["Brand"]}",
          "product_type": "watches",
          "variants": [
            {
              "price": "#{user_data["Price"]}",
              "sku": "#{user_data["Reference Number"]}",
              "inventory_quantity": "#{user_data["Quantity"]}"
            }]
        }
      })
      response = https.request(request)
      puts response.read_body
      product_id=JSON.parse(response.read_body)["product"]["id"]
      inventory_item_id=JSON.parse(response.read_body)["product"]["variants"][0]["inventory_item_id"]
      ################################################# Save product_id and inventory in watch.xlsx
      workbook,worksheet="",""
      workbook=RubyXL::Parser.parse("lib/watch.xlsx")
      worksheet=workbook[0]
      # headers=worksheet[0]
      # row_count=worksheet.sheet_data.rows.size
      header_count=28
      
      worksheet.insert_cell(0,header_count,"product_id")
      worksheet.insert_cell(idx,header_count,"#{product_id}")
      worksheet.insert_cell(0,header_count+1,"inventory_item_id")
      worksheet.insert_cell(idx,header_count+1,"#{inventory_item_id}")
      workbook.write("lib/watch.xlsx")
      ################################################# Metafield Data Of Watch to Upload
      #url = URI("https://{{api_key}}:{{api_password}}@{{store_name}}.myshopify.com/admin/api/{{api_version}}/products/{{product_id}}/metafields.json")
      url_meta =  URI("https://afc7bf55fcb3c9b22271d9b856cfb7c3:94eac404e1b0b14313534f7b9979ef92@protonshub.myshopify.com/admin/api/2022-01/products/#{product_id}/metafields.json")
      https1 = Net::HTTP.new(url_meta.host, url_meta.port)
      https1.use_ssl = true
      request1 = Net::HTTP::Post.new(url_meta)
      request1["Content-Type"] = "application/json"
      request1["x-shopify-access-token"]="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"
      counter1=1
      headers.each do |header|
        if header.is_a? String
          header1=header.strip.gsub(" ","_")
          header1=header1.strip.gsub("-","_")
        end
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
        metafield_id=JSON.parse(response.read_body)["metafield"]["id"]
        counter1+=1
        ################################################# Save metafield_id in watch.xlsx
        workbook,worksheet="",""
        workbook=RubyXL::Parser.parse("lib/watch.xlsx")
        worksheet=workbook[0]
        # headers=worksheet[0]
        # row_count=worksheet.sheet_data.rows.size
        column_count=28
        worksheet.insert_cell(0,column_count+counter1,"metafield_#{header1}_id")
        worksheet.insert_cell(idx,column_count+counter1,"#{metafield_id}")
        workbook.write("lib/watch.xlsx")
        #################################################
      end
      counter1=0
    end
  end
  ######################################################################################################
  desc "Upload data of jwellery from spreadsheet"  ################### Upload Jewellery
  task jewellery: :environment do 
    puts 'Uploading Data' # add this line
    data = Roo::Spreadsheet.open('lib/jewellery.xlsx') # open spreadsheet
    headers = data.row(1) # get header row
    data.each_with_index do |row, idx|
      next if idx == 0 # skip header
      user_data = Hash[[headers, row].transpose]
      if user_data["Product Name"]==nil
        break
      end
      ################################################ Normal Data Of Jewellery to Upload
      request.body = JSON.dump({
        "product": {
          "title": "#{user_data["Product Name"]}",          
          "body_html": "<strong>#{user_data["Description"]}</strong>",
          "vendor": "#{user_data["Brand"]}",
          "product_type": "jewelleries",
          "variants": [
            {
              "price": "#{user_data["Price"]}",
              "sku": "#{user_data["Reference Number"]}",
              # "tracked": true,
              "inventory_quantity": "#{user_data["Quantity"]}", 
              "option1": "#{user_data["Metal"]}"
            },
            {
              "price": "#{user_data["Price"]}",
              "sku": "#{user_data["Reference Number"]}",
              # "tracked": true,
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
      product_id=JSON.parse(response.read_body)["product"]["id"]
      inventory_item_id=JSON.parse(response.read_body)["product"]["variants"][0]["inventory_item_id"]
      ################################################# Save product_id in jewellery.xlsx
      workbook,worksheet="",""
      workbook=RubyXL::Parser.parse("lib/jewellery.xlsx")
      worksheet=workbook[0]
      # headers=worksheet[0]
      # row_count=worksheet.sheet_data.rows.size
      header_count=24 #column_count=header.count
      worksheet.insert_cell(0,header_count,"product_id")
      worksheet.insert_cell(idx,header_count,"#{product_id}")
      worksheet.insert_cell(0,header_count+1,"inventory_item_id")
      worksheet.insert_cell(idx,header_count+1,"#{inventory_item_id}")
      workbook.write("lib/jewellery.xlsx")
      ################################################# Metafield Data Of Jewellery to Upload
      #url = URI("https://{{api_key}}:{{api_password}}@{{store_name}}.myshopify.com/admin/api/{{api_version}}/products/{{product_id}}/metafields.json")
      url_meta =  URI("https://afc7bf55fcb3c9b22271d9b856cfb7c3:94eac404e1b0b14313534f7b9979ef92@protonshub.myshopify.com/admin/api/2022-01/products/#{product_id}/metafields.json")
      https1 = Net::HTTP.new(url_meta.host, url_meta.port)
      https1.use_ssl = true
      request1 = Net::HTTP::Post.new(url_meta)
      request1["Content-Type"] = "application/json"
      request1["x-shopify-access-token"]="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"
      counter1=1
      headers.each do |header|
        if header.is_a? String
          header1=header.strip.gsub(" ","_")
          header1=header1.strip.gsub("-","_")
        end
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
        metafield_id=JSON.parse(response.read_body)["metafield"]["id"]
        counter1+=1
        ################################################# Save metafield_regarding_every_column_id in jewellery.xlsx
        workbook,worksheet="",""
        workbook=RubyXL::Parser.parse("lib/jewellery.xlsx")
        worksheet=workbook[0]
        # row_count=worksheet.sheet_data.rows.size
        column_count=24   # we have mentioned headers.count & worksheet.cols.size
        worksheet.insert_cell(0,column_count+counter1,"metafield_#{header1}_id")
        worksheet.insert_cell(idx,column_count+counter1,"#{metafield_id}")
        workbook.write("lib/jewellery.xlsx")
        #################################################
      end
      counter1=0
    end
  end
end