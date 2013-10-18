json.products @products do |product|
  json.partial! "products/product", product: product
  json.image do
    json.list product.image.list.url if product.image
    json.grid product.image.grid.url if product.image
  end
end
json.current_page @products.current_page
json.total_pages @products.total_pages
json.total_count @products.total_count
