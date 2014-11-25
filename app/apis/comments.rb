class Comments < Grape::API
  helpers CommentsHelper

  resources 'comments' do
    desc 'create comments with id of order or product'
    params do
      requires :device_id, type: String, desc: "if have the device info"
      requires :sign, type: String, desc: "Sign value"
      requires :id, type: String, desc: "id of order or line_item"
      requires :type, type: String, desc: "decide is the order or line_item"
      requires :score, type: Integer, desc: "comment score", values: (0..5).to_a
      optional :content, type: String, desc: "comments content"
    end
    post ':create_comment', jbuilder: 'orders/order' do
      verify_sign
      @comment = create_comment(params)
      @order = Order.find params[:id]
      status 500 unless @comment && @order
    end
  end
end
