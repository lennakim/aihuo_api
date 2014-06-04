class Products < Grape::API
  # define helpers with a block
  helpers do
    def query_params
      # 传递的是二级分类过滤器中的 category 和 brand
      if params[:tags]
        params[:match] = "match_all"
        params[:tags].inject([]) do |tags, tag|
          tags << tag
        end
      # 传递的是一个 tag 或者搜索关键词
      elsif params[:tag]
        tag = Tag.find_by(name: params[:tag])
        if tag
          tag = tag.self_and_descendants.collect(&:name)
          tag = tag[0] if tag.size == 1 # 如果 tag 数组只有一个元素
        end
        tag || params[:tag]
      # 传递的是一组产品ID
      elsif params[:id]
        params[:id].inject([]) do |ids, id|
          ids << EncryptedId.decrypt(Product.encrypted_id_key, id).to_i
        end
      end
    end

    def date_param
      date = request.headers["Registerdate"] || params[:register_date]
      date.to_date if date
    end
  end

  resources :products do
    desc "Listing products."
    params do
      optional :id, type: Array, desc: "Product ids."
      optional :tag, type: String, desc: "Tag name or keyword."
      optional :tags, type: Array, desc: "Categroy and brand."
      optional :match, type: String, default: "any", desc: "Match filter type."
      optional :min_price, type: String, desc: "Min price."
      optional :max_price, type: String, desc: "Max price."
      optional :register_date, type: String, desc: "Date looks like '20130401'."
      optional :sku_visible, type: Boolean, default: false, desc: "Return skus or not."
      optional :page, type: Integer, desc: "Page number."
      optional :per_page, type: Integer, default: 10, desc: "Per page value."
    end
    get "/", jbuilder: 'products/products' do
      @products =
        paginate(
          Product.search(query_params, date_param, Date.today, params[:match])
            .price_between(params[:min_price], params[:max_price])
        )
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
        cache(key: [:v2, :product, product, params[:page], params[:per_page]], expires_in: 1.days) do
          @trades = paginate(product.orders.by_filter(params[:filter]).distinct.order("created_at DESC"))
        end
      end
    end

  end
end
