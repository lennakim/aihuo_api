class Orders < Grape::API
  helpers do
    def order_params
      current_application
      params[:order][:device_id] = params[:device_id]
      params[:order][:application_id] = @application.id

      params[:order][:line_items_attributes].values.each do |item|
        product_id = Product.decrypt(Product.encrypted_id_key, item[:product_id])
        property_id = ProductProp.decrypt(ProductProp.encrypted_id_key, item[:product_prop_id])
        item[:product_id] = product_id
        item[:product_prop_id] = property_id
      end
      # http://qiita.com/milkcocoa/items/8d827ac92b179c8aa7e4
      # https://github.com/intridea/grape/issues/404
      declared(params, include_missing: false)[:order]
    end

    def format_amount
      params[:amount].to_f
    end

    def validate_remote_host
      unless request.env["HTTP_SAEAPPNAME"] == "paybank"
        error!({error: "unknown host"}, 500)
      end
    end
  end

  resources 'orders' do
    desc "Listing orders of the user."
    params do
      requires :device_id, type: String, desc: "Device ID."
      optional :page, type: Integer, desc: "Page number."
      optional :per_page, type: Integer, default: 10, desc: "Per page value."
    end
    get '/', jbuilder: 'orders/orders' do
      @orders = paginate(Order.where(device_id: params[:device_id]))
    end

    desc "Create an order."
    params do
      requires :device_id, type: String, desc: "Device ID"
      optional :api_key, type: String, desc: "Application API Key"
      requires :sign, type: String, desc: "Sign value"
      group :order, type: Hash do
        requires :line_items_attributes, type: Hash, desc: "商品"
        requires :name, type: String, desc: "姓名"
        requires :phone, type: String, desc: "电话"
        optional :shipping_province, type: String, desc: "省"
        optional :shipping_city, type: String, desc: "市"
        optional :shipping_district, type: String, desc: "区"
        optional :shipping_address, type: String, desc: "详细地址"
        requires :shipping_charge, type: Integer, desc: "运费"
        optional :pay_type, type: Integer, values: [0, 1], default: 1, desc: "支付方法"
        optional :comment, type: String, desc: "买家留言"
        optional :device_id, type: String, desc: "Device ID"
        optional :application_id, type: Integer, desc: "Application ID"
      end
      optional :coupon, type: String, desc: "优惠劵"
    end
    post '/', jbuilder: 'orders/order' do
      if sign_approval?
        @order = Order.newly.build(order_params)
        if @order.save
          @order.calculate_total_by_coupon(params[:coupon], true, true)
          original_order_id = @order.id # 记录目前订单ID
          if @order.need_merge?
            @order.merge_pending_orders
            # HACK: Reset @order to origin order
            # 合并订单后本订单删除，返回原始订单
            @order = @order.find_original_order
          end
          type = original_order_id == @order.id ? :create : :merge # 如果ID不同证明是合并订单
          @order.send_confirm_sms(type)
          @order
        else
          status 500
        end
      else
        error! "Access Denied", 401
      end
    end

    params do
      requires :id, type: String, desc: "Order id."
      requires :device_id, type: String, desc: "Device ID."
    end
    route_param :id do

      before do
        begin
          @order = Order.where(device_id: params[:device_id]).find_by_encrypted_id(params[:id])
        rescue Exception => e
          error! "Order not found", 404
        end
      end

      desc "Return an order."
      get "/", jbuilder: 'orders/order'

      desc "Cancel or Delete an order."
      delete "/", jbuilder: 'orders/order' do
        status_code = @order.cancel_or_delete_by_client ? 202 : 200
        status status_code
      end

      desc "Update an order address info"
      params do
        optional :api_key, type: String, desc: "Application API Key"
        requires :sign, type: String, desc: "Sign value"
        group :order, type: Hash do
          optional :name, type: String, desc: "姓名"
          requires :phone, type: String, desc: "电话"
          optional :shipping_province, type: String, desc: "省"
          optional :shipping_city, type: String, desc: "市"
          optional :shipping_district, type: String, desc: "区"
          optional :shipping_address, type: String, desc: "详细地址"
        end
      end
      put "/update_address", jbuilder: 'orders/order' do
        if sign_approval?
          @order = Order.newly.where(device_id: params[:device_id]).find_by_encrypted_id(params[:id])
          @order.update(params[:order])
        else
          error! "Access Denied", 401
        end
      end

      desc "Update an order payments state(for sae php server)."
      params do
        requires :amount, type: String, regexp: /^\d+(?:\.\d{0,2})?$/, desc: "Payment amount."
        requires :transaction_no, type: String, desc: "transaction number."
      end
      put "/", jbuilder: 'orders/order' do
        validate_remote_host
        begin
          @order = Order.unpaid.where(device_id: params[:device_id]).find_by_encrypted_id(params[:id])
          if @order.transaction_need_process?(params[:transaction_no])
            @order.process_payment(params[:transaction_no], format_amount)
            @order.send_confirm_sms(:update)
          end
        rescue Exception => e
          error!({
            error: "unexpected error",
            detail: "Can not find unpaid order with id #{params[:id]}"
          }, 500)
        end
      end
    end

  end
end
