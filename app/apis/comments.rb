class Comments < Grape::API
  helpers CommentsHelper

  resources 'orders' do
    params do
      use :id_and_device
    end
    route_param :id do

      before do
        begin
          @order = Order.where(device_id: params[:device_id]).find_by_encrypted_id(params[:id])
        rescue Exception => e
          error! "Order not found", 404
        end
      end

      desc 'Create a comment for order.'
      params do
        use :comment
      end
      resources 'comments' do
        post '/', jbuilder: 'comments/comment' do
          verify_sign
          @comment = find_or_create_comment(@order)
        end
      end

      params do
        requires :line_item_id, type: String, desc: "Line Item id"
      end
      resources 'line_items' do
        route_param :line_item_id do

          before do
            begin
              @line_item = @order.line_items.find_by_encrypted_id(params[:line_item_id])
            rescue Exception => e
              error! "Line Item not found", 404
            end
          end

          desc 'Create a comment for line item.'
          params do
            use :comment
          end
          resources 'comments' do
            post '/', jbuilder: 'comments/comment' do
              verify_sign
              @comment = find_or_create_comment(@line_item)
            end
          end
        end
      end
    end

  end
end
