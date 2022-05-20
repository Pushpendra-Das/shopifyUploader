require 'roo'
require "uri"
require "json"
require "net/http"
require 'xlsxwriter'
    
# url = URI("https://#{ShopifyAPI::Context.api_key}:#{ShopifyAPI::Context.api_secret_key}@#{ShopifyAPI::Context.host_name}.myshopify.com/admin/api/#{ShopifyAPI::Context.api_version}/products.json")
url =  URI("https://afc7bf55fcb3c9b22271d9b856cfb7c3:94eac404e1b0b14313534f7b9979ef92@protonshub.myshopify.com/admin/api/2022-01/products.json")


https = Net::HTTP.new(url.host, url.port)
https.use_ssl = true

request = Net::HTTP::Post.new(url)
request["Content-Type"] = "application/json"
request["x-shopify-access-token"]="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"

namespace :import do
  desc "Import data of watch from spreadsheet" ############################# Upload Watch
  task watch: :environment do
    puts 'Importing Data' # add this line
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
          "product_type": "watches"
        }
      })
      response = https.request(request)
      puts response.read_body
      product_id=JSON.parse(response.read_body)["product"]["id"]
      ################################################# Save product_id in watch.xlsx
      workbook,worksheet,headers,row_count="","","",""
      workbook=RubyXL::Parser.parse("lib/watch.xlsx")
      worksheet=workbook[0]
      headers=worksheet[0]
      row_count=worksheet.sheet_data.rows.size
      worksheet.insert_cell(0,25,product_id)
      worksheet.insert_cell(idx,25,"#{product_id}")
      workbook.write("lib/watch.xlsx")
      ################################################# Metafield Data Of Watch to Upload
      #url = URI("https://{{api_key}}:{{api_password}}@{{store_name}}.myshopify.com/admin/api/{{api_version}}/products/{{product_id}}/metafields.json")
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
        metafield_id=JSON.parse(response.read_body)["metafield"]["id"]

        ################################################# Save metafield_id in watch.xlsx
        workbook=RubyXL::Parser.parse("lib/watch.xlsx")
        worksheet=workbook[0]
        headers=worksheet[0]
        row_count=worksheet.sheet_data.rows.size
        
        worksheet.insert_cell(0,26,metafield_id)
        worksheet.insert_cell(idx,26,"#{metafield_id}")
        workbook.write("lib/watch.xlsx")
        #################################################
      end
    end
  end
  desc "Import data of jwellery from spreadsheet"  ################### Upload Jewellery
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
      ################################################ Normal Data Of Jewellery to Upload
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
      product_id=JSON.parse(response.read_body)["product"]["id"]
      ################################################# Save product_id in jewellery.xlsx
      workbook=RubyXL::Parser.parse("lib/jewellery.xlsx")
      worksheet=workbook[0]
      headers=worksheet[0]
      row_count=worksheet.sheet_data.rows.size
      
      worksheet.insert_cell(0,24,product_id)
      worksheet.insert_cell(idx,24,"#{product_id}")
      workbook.write("lib/jewellery.xlsx")
      ################################################# Metafield Data Of Jewellery to Upload
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
        metafield_id=JSON.parse(response.read_body)["metafield"]["id"]

        ################################################# Save metafield_id in jewellery.xlsx
        workbook=RubyXL::Parser.parse("lib/jewelleries.xlsx")
        worksheet=workbook[0]
        headers=worksheet[0]
        row_count=worksheet.sheet_data.rows.size
        
        worksheet.insert_cell(0,25,metafield_id)
        worksheet.insert_cell(idx,25,"#{metafield_id}")
        workbook.write("lib/watch.xlsx")
        #################################################
      end
    end
  end
end