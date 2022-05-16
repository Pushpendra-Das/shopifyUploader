ShopifyAPI::Context.setup(
    api_key: "afc7bf55fcb3c9b22271d9b856cfb7c3",
    api_secret_key: "94eac404e1b0b14313534f7b9979ef92",
    host_name: "protonshub",
    scope: "write_products, read_products",
    session_storage: ShopifyAPI::Auth::FileSessionStorage.new, # This is only to be used for testing, more information in session docs
    is_embedded: false, # Set to true if you are building an embedded app
    is_private: false, # Set to true if you are building a private app
    api_version: "2022-01" # The vesion of the API you would like to use
  )