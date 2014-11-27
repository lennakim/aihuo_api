json.ignore_nil!
json.partial! "orders/order", order: @order
json.payment_state @order.payment_state
json.payment_total @order.payment_total
# seems that we do not use this code. can remove next line later.
# json.comment @order.comment if @order.comment.present?
json.consignee do
  json.name @order.name
  json.address @order.shipping_address
  json.phone @order.phone
  json.postal_code @order.postal_code
end
json.line_items @order.line_items do |item|
  json.partial! "line_items/line_item", line_item: item
end
json.commented @order.commented?
