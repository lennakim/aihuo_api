json.partial! "orders/order", order: @order
json.line_items @order.line_items do |item|
  json.partial! "line_items/line_item", line_item: item
end

