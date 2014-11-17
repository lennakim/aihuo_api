class Orders < Grape::API
  helpers OrdersHelper

  resources 'orders' do
    desc "Listing orders of the user."
    params do
      use :orders
    end
    get '/', jbuilder: 'orders/orders' do
      @orders = paginate(Order.where(device_id: params[:device_id]))
    end

    desc "Create an order."
    params do
      use :order
    end
    post '/', jbuilder: 'orders/order' do
      verify_sign
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
    end

    params do
      use :order_and_device
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
        use :update_address
      end
      put "/update_address", jbuilder: 'orders/order' do
        verify_sign
        @order = Order.newly.where(device_id: params[:device_id]).find_by_encrypted_id(params[:id])
        @order.update(params[:order])
      end

      desc "Update an order payments state(for sae php server)."
      params do
        use :update_payments_state
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
