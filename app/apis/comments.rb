class Comments < Grape::API
  helpers CommentsHelper

  resources 'comments' do
    desc 'create comments with id of order or product'
    params do
      use :comment
    end
    post '/', jbuilder: 'orders/order' do
      verify_sign
      @comment, @order = create_comment_and_get_order(params)
      status 500 unless @comment
      status 202 unless @order
    end
  end
end
