json.products @products do |product|
  json.partial! "products/product", product: product
  json.image do
    json.list product.image.list.url if product.image
    json.grid product.image.grid.url if product.image
  end
end
json.total_number @total_number
