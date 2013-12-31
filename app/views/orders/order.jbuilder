json.partial! "orders/order", order: @order
json.express_number @order.express_number if @order.express_number.present?
json.comment @order.comment if @order.comment.present?
json.line_items @order.line_items do |item|
  json.partial! "line_items/line_item", line_item: item
end
