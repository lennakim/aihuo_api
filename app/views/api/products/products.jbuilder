json.products @products do |product|
  json.id product.to_param
  json.title product.title
  json.market_price product.market_price
  json.retail_price product.retail_price
  json.image do
    json.list product.image.list.url if product.image
    json.grid product.image.grid.url if product.image
  end
  json.labels product.labels
end
