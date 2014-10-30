json.products @products do |product|
  json.cache! product.cache_key, expires_in: 4.hours do
    json.partial! "products/product", product: product
  end

  if params[:sku_visible] == true
    json.product_props product.product_props do |product_prop|
      json.cache! product_prop.cache_key, expires_in: 4.hours do
        json.partial! "products/product_prop", product_prop: product_prop
      end
    end
  end
end
