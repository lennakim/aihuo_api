json.id photo.to_param
if photo.image
  json.image do
    json.iphone photo.carrierwave_image(:grid, :url)
    json.ipad photo.carrierwave_image(:retain, :url)
  end
end
