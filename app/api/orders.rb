module API
  class Orders < Grape::API
    helpers do
      def order_params
        current_application
        params[:order][:device_id] = params[:device_id]
        params[:order][:application_id] = @application.id

        params[:order][:line_items_attributes].values.each do |item|
          product_id = EncryptedId.decrypt(Product.encrypted_id_key, item[:product_id])
          property_id = EncryptedId.decrypt(ProductProp.encrypted_id_key, item[:product_prop_id])
          item[:product_id] = product_id
          item[:product_prop_id] = property_id
        end
        # http://qiita.com/milkcocoa/items/8d827ac92b179c8aa7e4
        # https://github.com/intridea/grape/issues/404
        declared(params, include_missing: false)[:order]
      end
    end

    resources 'orders' do
      desc "Listing orders of the user."
      params do
        requires :device_id, type: String, desc: "Device ID."
        optional :page, type: Integer, desc: "Page number."
        optional :per, type: Integer, default: 10, desc: "Per page value."
      end
      get '/', jbuilder: 'orders/orders' do
        @orders = Order.where(device_id: params[:device_id]).page(params[:page]).per(params[:per])
      end

      desc "Create an order."
      params do
        requires :device_id, type: String, desc: "Device ID"
        requires :api_key, type: String, desc: "Application API Key"
        group :order do
          requires :line_items_attributes, type: Hash, desc: "商品"
          requires :name, type: String, desc: "姓名"
          requires :phone, type: String, desc: "电话"
          optional :shipping_province, type: String, desc: "省"
          optional :shipping_city, type: String, desc: "市"
          optional :shipping_district, type: String, desc: "区"
          optional :shipping_address, type: String, desc: "详细地址"
          requires :shipping_charge, type: Integer, desc: "运费"
          optional :comment, type: String, desc: "买家留言"
          optional :device_id, type: String, desc: "Device ID"
          optional :application_id, type: Integer, desc: "Application ID"
        end
      end
      post '/', jbuilder: 'orders/order' do
        @order = Order.newly.build(order_params)
        @order.save
      end

      params do
        requires :id, type: String, desc: "Order id."
        requires :device_id, type: String, desc: "Device ID."
      end
      route_param :id do
        desc "Return an order"
        get "/", jbuilder: 'orders/order' do
          @order = Order.where(device_id: params[:device_id]).find_by_encrypted_id(params[:id])
        end

        desc "Delete an order."
        delete "/", jbuilder: 'orders/order' do
          @order = Order.done.where(device_id: params[:device_id]).find_by_encrypted_id(params[:id])
          status 202 if @order.destroy
        end
      end

    end
  end
end
