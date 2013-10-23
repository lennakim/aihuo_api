json.products @products do |product|
  json.partial! "products/product", product: product
  if product.image
    json.image do
      json.list product.carrierwave_image(:list, :url)
      json.grid product.carrierwave_image(:grid, :url)
    end
  end
end
json.current_page @products.current_page
json.total_pages @products.total_pages
json.total_count @products.total_count
