module API
  class Carts < Grape::API
    helpers do
      def current_cart
        current_application
        @cart = Cart.where(device_id: params[:device_id], application_id: @application.id).first_or_create!
      end

      def cart_params
        params[:cart][:line_items_attributes].values.each do |item|
          product_id = EncryptedId.decrypt(Product.encrypted_id_key, item[:product_id])
          property_id = EncryptedId.decrypt(ProductProp.encrypted_id_key, item[:product_prop_id])
          item[:product_id] = product_id
          item[:product_prop_id] = property_id
        end
        # http://qiita.com/milkcocoa/items/8d827ac92b179c8aa7e4
        # https://github.com/intridea/grape/issues/404
        declared(params, include_missing: false)[:cart]
      end
    end

    resources 'carts' do
      desc "Get current cart."
      params do
        requires :device_id, type: String, desc: "Device ID"
        requires :api_key, type: String, desc: "Application API Key"
      end
      get '/', jbuilder: 'carts/cart' do
        current_cart
      end

      desc "Create a cart."
      params do
        requires :device_id, type: String, desc: "Device ID"
        requires :api_key, type: String, desc: "Application API Key"
        requires :sign, type: String, desc: "Sign value"
        group :cart do
          requires :line_items_attributes, type: Hash, desc: "商品"
          optional :application_id, type: Integer, desc: "Application ID"
        end
      end
      post '/', jbuilder: 'carts/cart' do
        if sign_approval?
          current_cart
          @cart.clear_items!
          status 500 unless @cart.update_attributes(cart_params)
        else
          error! "Access Denied", 401
        end
      end
    end
  end
end

