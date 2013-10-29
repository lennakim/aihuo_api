module API
  class Orders < Grape::API
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

