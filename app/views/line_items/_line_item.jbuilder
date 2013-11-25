json.product_id line_item.product.to_param
json.product_prop_id line_item.product_prop.to_param
json.title line_item.product.title
json.market_price line_item.original_price.to_f
json.retail_price line_item.sale_price.to_f
json.photos line_item.product.photos do |photo|
  json.partial! "products/photo", photo: photo
end
json.name line_item.product_prop_name
json.value line_item.product_prop_value
json.quantity line_item.quantity
