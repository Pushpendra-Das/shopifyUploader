class ProductsController < ApplicationController
  def index

  end

  def show
  end

  def new
  end

  def create
    test_session = ShopifyAPI::Utils::SessionUtils.load_current_session(auth_header: "Bearer token", cookies: request.cookies,  is_online: true    )
    product = ShopifyAPI::Product.new(session: test_session)
    product.title = "Burton Custom Freestyle 151"
    product.body_html = "<strong>Good snowboard!</strong>"
    product.vendor = "Burton"
    product.product_type = "Snowboard"
    product.variants = [
      {
        "option1" => "First",
        "price" => "10.00",
        "sku" => "123"
      },
      {
        "option1" => "Second",
        "price" => "20.00",
        "sku" => "123"
      }
    ]
    product.save
  end

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
