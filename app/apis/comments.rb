class Comments < Grape::API
  helpers CommentsHelper

  resources 'comments' do
    desc 'create comments with id of order or product'
    params do
      optional :order, type: Hash do
        requires :score, type: Integer, desc: "order's score", values: (0..5).to_a
      end
      optional :line_item, type: Hash do
        requires :product_id, type: String, desc: "help to find line_item"
        requires :score, type: Integer, desc: "line_item's score", values: (0..5).to_a
        optional :content, type: String, desc: "comments content"
      end
      use :comment_member_relate
      requires :sign, type: String, desc: "Sign value"
      requires :id, type: String, desc: "id of order or line_item"
    end
    post ':create_comment', jbuilder: 'orders/order' do
      verify_sign
      @comment = get_comment(params)
      @order = Order.find params[:id]
      status 500 unless @comment && @order
    end
  end
end
  # desc 'Listing comments'
  # params do
  #   optional :order_id, type: Integer, desc: 'order id '
  #   optional :line_item_id, type: Integer, desc: 'Date looks like 20130401.'
  #   exactly_one_of :order_id, :line_item_id
  #   use :comment_member_relate
  # end

  # get '/', jbuilder: 'comments/comments' do
  #   verify_sign
  #   comments = if params[:order_id]
  #       order = Order.find_by_id(params[:order_id])
  #       have_this_order? order
  #       order.order_comment
  #       # Comment.where("order_id = ? OR (commable_id = ? AND commable_type = 'Order')", order.id, order.id)
  #     elsif params[:line_item_id]
  #       LineItem.find_by_id(params[:line_item_id]).try(:comment)
  #   end

  #   @comments = (comments.is_a?(Comment) ? comments : paginate(comments))
  # end
