json.products @products do |product|
  json.id product.id
  json.title product.title
  json.market_price product.market_price
  json.retail_price product.retail_price
  json.image do
    json.list product.image.list.url if product.image
    json.grid product.image.grid.url if product.image
  end
  json.popularize product.popularize
end
