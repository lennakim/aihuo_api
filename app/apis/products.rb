class Products < Grape::API
  helpers ProductsHelper

  resources :products do
    desc "Listing products."
    params do
      use :products
    end
    get "/", jbuilder: 'products/products' do
      products = Rails.cache.fetch(products_cache_key, expires_in: 2.hours) do
        products = Product.search(query_params, date_param, Date.today, params[:match])
        products = products.price_between(params[:min_price], params[:max_price])
        products.sorted_by_tag(params[:tag])
      end
      @products = products ? paginate(products) : products
    end

    params do
      requires :id, type: String, desc: "Product ID."
    end
    route_param :id do
      desc "Return a product."
      get "/", jbuilder: 'products/product' do
        cache(key: [:v2, :product, params[:id]], expires_in: 4.hours) do
          @product = Product.find(params[:id])
        end
      end

      desc "Listing trades of the product."
      params do
        use :trades
      end
      get :trades, jbuilder: 'trades/trades' do
        trades = Rails.cache.fetch(key: trades_cache_key, expires_in: 2.hours) do
          product = Product.find(params[:id])
          product.orders.by_filter(params[:filter]).distinct.order("created_at DESC")
        end
        @product_id = Product.decrypt(Product.encrypted_id_key, params[:id])
        @trades = trades ? paginate(trades) : trades
      end
    end

  end
end
