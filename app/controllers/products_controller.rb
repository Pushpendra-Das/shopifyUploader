class ProductsController < ApplicationController
  def index

  end

  def show
  end

  def new
  end

  def create
    require "uri"
    require "json"
    require "net/http"
    
    url = URI("https://#{ShopifyAPI::Context.api_key}:#{ShopifyAPI::Context.api_secret_key}@#{ShopifyAPI::Context.host_name}.myshopify.com/admin/api/#{ShopifyAPI::Context.api_version}/products.json")

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = "application/json"
    request["x-shopify-access-token"]="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"




    request.body = JSON.dump({
      "product": {
        "title": "Burton Custom Freestyle 151",
        "body_html": "<strong>Good snowboard!</strong>",
        "vendor": "Burton",
        "product_type": "Snowboard",
        "variants": [
          {
            "option1": "Blue",
            "option2": "155"
          },
          {
            "option1": "Black",
            "option2": "159"
          }
        ],
        "options": [
          {
            "name": "Color",
            "values": [
              "Blue",
              "Black"
            ]
          },
          {
            "name": "Size",
            "values": [
              "155",
              "159"
            ]
          }
        ]
      }
    })
    response = https.request(request)
    
    render json: {message: "Created successfully"}
  end

  # def create
  #   $test_session=ShopifyAPI::Session.new(domain: "protonshub.myshopify.com", token: "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", api_version: "2022-01")
  #   #test_session = ShopifyAPI::Utils::SessionUtils.load_current_session(auth_header: request.auth_header, cookies: request.cookies, is_online: true )
  #   product = ShopifyAPI::Product.new(session: $test_session)
  #   product.title = "Burton Custom Freestyle 151"
  #   product.body_html = "<strong>Good snowboard!</strong>"
  #   product.vendor = "Burton"
  #   product.product_type = "Snowboard"
  #   product.variants = [
  #     {
  #       "option1" => "First",
  #       "price" => "10.00",
  #       "sku" => "123"
  #     },
  #     {
  #       "option1" => "Second",
  #       "price" => "20.00",
  #       "sku" => "123"
  #     }
  #   ]
  #   product.save
  # end

  def update
    test_session = ShopifyAPI::Utils::SessionUtils.load_current_session(
      auth_header: request.auth_header,
      cookies: request.cookies,
      is_online: true
    )
    
    product = ShopifyAPI::Product.new(session: test_session)
    product.id = 632910392
    product.images = [
      {
        "id" => 850703190
      },
      {
        "id" => 562641783
      },
      {
        "id" => 378407906
      },
      {
        "src" => "http://example.com/rails_logo.gif"
      }
    ]
    product.variants = [
      {
        "id" => 808950810,
        "price" => "2000.00",
        "sku" => "Updating the Product SKU"
      },
      {
        "id" => 49148385
      },
      {
        "id" => 39072856
      },
      {
        "id" => 457924702
      }
    ]
    product.save()
    
  end

  def destroy
  end
end
