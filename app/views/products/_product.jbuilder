json.id product.to_param
json.title product.title
json.market_price product.market_price.to_f
json.retail_price product.retail_price.to_f
json.(product, :labels, :out_of_stock, :auto_pick_up)
if product.image
  json.image do
    json.list product.carrierwave_image(:list, :url)
    json.grid product.carrierwave_image(:grid, :url)
  end
end
json.video product.carrierwave_video(nil, :url) if product.video
