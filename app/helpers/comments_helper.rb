module CommentsHelper
  extend Grape::API::Helpers

  params :id_and_device do
    requires :id, type: String, desc: "Order id"
    requires :device_id, type: String, desc: "device id"
  end

  params :comment do
    optional :api_key, type: String, desc: "Application API Key"
    requires :sign, type: String, desc: "Sign value"
    group :comment, type: Hash do
      requires :score, type: Integer, values: (0..5).to_a, default: 5, desc: "comment score"
      optional :content, type: String, desc: "comments content"
      optional :device_id, type: String, desc: "Device ID"
      optional :order_id, type: String, desc: "Order ID"
    end
  end

  def comment_params
    params[:comment][:device_id] = params[:device_id]
    params[:comment][:order_id] = Order.decrypt(Order.encrypted_id_key, params[:id])
    declared(params, include_missing: false)[:comment]
  end

  def find_or_create_comment(obj)
    obj.review || obj.create_review(comment_params)
  end

end
