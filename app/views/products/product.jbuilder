json.partial! "products/product", product: @product
json.detail_link @product.detail_link
json.product_props @product.product_props do |product_prop|
  json.partial! "products/product_prop", product_prop: product_prop
end
json.photos @product.photos do |photo|
  json.partial! "products/photo", photo: photo
end
if @product.recommend_list
  json.recommends @product.recommend_products do |product|
    json.partial! "products/product", product: product
  end
end
