module Mobile
  class Products < Grape::API
    # define helpers with a block
    helpers do
      def tags
        if params[:tag]
          tag = Tag.find_by_name(params[:tag])
          tag.self_and_descendants.collect(&:name) if tag
        end
      end
    end

    resources :products do
      desc "Listing products."
      params do
        optional :tag, type: String, desc: "Tag name."
        optional :page, type: Integer, desc: "Page number."
        optional :per, type: Integer, default: 10, desc: "Per page value."
      end
      get "/", jbuilder: 'products/products' do
        @products = Product.tagged_with(tags, :any => true).page(params[:page]).per(params[:per])
        # Tip:
        # `products.size` is different from `products.count`.
        # if u want to use `count` method, please remember to add `distinct` method.
        # Example: `Product.tagged_with(tags, :any => true).select(:id).distinct.count`
        @total_number = @products.total_count
      end

      params do
        requires :id, type: String, desc: "Product ID."
      end
      route_param :id do
        desc "Return a product."
        get "/", jbuilder: 'products/product' do
          @product = Product.find(params[:id])
        end

        desc "Listing trades of the product."
        params do
          optional :page, type: Integer, desc: "Page number."
          optional :page, type: Integer, desc: "Page number."
          optional :per, type: Integer, default: 10, desc: "Per page value."
        end
        get :trades, jbuilder: 'trades/trades' do
          product = Product.find(params[:id])
          @trades = product.orders.order("created_at DESC").page(params[:page]).per(params[:per])
          @total_number = product.orders.count
        end
      end

    end
  end
end

