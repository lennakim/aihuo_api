module Mobile
  class Products < Grape::API
    # define helpers with a block
    helpers do
      def tags
        if params[:tag]
          tag = Tag.find_by_name(params[:tag])
          tag.children.collect(&:name) << params[:tag] if tag
        end
      end
    end

    resources :products do
      desc "Listing of products."
      params do
        optional :tag, type: String, desc: "Tag name."
        optional :page, type: Integer, desc: "Page number."
        optional :per, type: Integer, default: 10, desc: "Per page value."
      end
      get "/", jbuilder: 'products/products' do
        @products = Product.tagged_with(tags, :any => true).page(params[:page]).per(params[:per])
      end
    end
  end
end

