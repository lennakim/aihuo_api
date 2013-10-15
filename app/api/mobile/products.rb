module Mobile
  class Products < Grape::API
    resources :products do
      desc "Listing of articles."
      params do
        optional :page, type: Integer, desc: "Page number."
        optional :per, type: Integer, default: 10, desc: "Page number."
      end
      get "/", jbuilder: 'products/products' do
        @products = Product.page(params[:page]).per(params[:per])
      end
    end
  end
end

