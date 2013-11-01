json.id @cart.to_param
json.line_items @cart.line_items do |item|
  json.partial! "line_items/line_item", line_item: item
end
