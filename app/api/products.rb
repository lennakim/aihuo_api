class Products < Grape::API
  # define helpers with a block
  helpers do
    def query_params
      if params[:tag]
        tag = Tag.find_by_name(params[:tag])
        tag = tag.self_and_descendants.collect(&:name) if tag
        tag || params[:tag]
      elsif params[:id]
        params[:id].inject([]) do |ids, id|
          ids << EncryptedId.decrypt(Product.encrypted_id_key, id).to_i
        end
      end
    end

    def data_param
      date = request.headers["Registerdate"] || params[:register_date]
      date.to_date if date
    end
  end

  resources :products do
    desc "Listing products."
    params do
      optional :id, type: Array, desc: "Product ids."
      optional :tag, type: String, desc: "Tag name."
      optional :register_date, type: String, desc: "Date looks like '20130401'."
      optional :sku_visible, type: Boolean, default: false, desc: "Should return skus or not."
      optional :page, type: Integer, desc: "Page number."
      optional :per_page, type: Integer, default: 10, desc: "Per page value."
    end
    get "/", jbuilder: 'products/products' do
      @products = paginate(Product.search(query_params, data_param, Date.today))
    end

    params do
      requires :id, type: String, desc: "Product ID."
    end
    route_param :id do
      desc "Return a product."
      get "/", jbuilder: 'products/product' do
        @product = Product.find(params[:id])
        cache(key: [:v2, :product, @product], expires_in: 2.days) do
          @product
        end
      end

      desc "Listing trades of the product."
      params do
        optional :filter, type: Symbol, values: [:rated, :all], default: :all, desc: "Filtering trades with commented or not."
        optional :page, type: Integer, desc: "Page number."
        optional :per_page, type: Integer, default: 10, desc: "Per page value."
      end
      get :trades, jbuilder: 'trades/trades' do
        product = Product.find(params[:id])
        @trades = paginate(product.orders.by_filter(params[:filter]).distinct.order("created_at DESC"))
      end
    end

  end
end
