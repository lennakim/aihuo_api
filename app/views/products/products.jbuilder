json.products @products do |product|
  json.partial! "products/product", product: product
  if params[:sku_visible] == true
    json.product_props product.product_props do |product_prop|
      json.partial! "products/product_prop", product_prop: product_prop
    end
  end
end
