module OrdersHelper
  extend Grape::API::Helpers

  params :orders do
    requires :device_id, type: String, desc: "Device ID."
    optional :page, type: Integer, desc: "Page number."
    optional :per_page, type: Integer, default: 10, desc: "Per page value."
  end

  params :order do
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

  params :update_address do
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

  params :update_payments_state do
    requires :amount, type: String, regexp: /^\d+(?:\.\d{0,2})?$/, desc: "Payment amount."
    requires :transaction_no, type: String, desc: "transaction number."
  end

  params :order_and_device do
    requires :id, type: String, desc: "Order id."
    requires :device_id, type: String, desc: "Device ID."
  end

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
    unless (request.env["HTTP_X_REAL_IP"] == "10.162.41.36" or request.env["HTTP_SAEAPPNAME"] == "paybank")
      error!({error: "unknown host"}, 500)
    end
  end
end
