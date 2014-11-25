json.product_id line_item.product.to_param
json.id line_item.to_param
json.product_prop_id line_item.product_prop.to_param
json.title line_item.product.title
json.market_price line_item.purchase_price.to_f
json.retail_price line_item.sale_price.to_f
json.name line_item.product_prop_name
json.value line_item.product_prop_value
json.quantity line_item.quantity
if line_item.product.image
  json.image do
    json.list line_item.product.carrierwave_image(:list, :url)
    json.grid line_item.product.carrierwave_image(:grid, :url)
  end
end
json.commented (line_item.comment ? false : true)
