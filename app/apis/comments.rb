class Comments < Grape::API
  helpers CommentsHelper

  resources 'comments' do
    desc 'create comments with id of order or product'
    params do
      use :comment
    end
    post ':create_comment', jbuilder: 'orders/order' do
      verify_sign
      @comment = create_comment(params)
      @order = Order.find params[:id]
      status 500 unless @comment && @order
    end
  end
end
