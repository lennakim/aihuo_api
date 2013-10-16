json.id photo.to_param
json.image do
  json.iphone photo.image.grid.url
  json.ipad photo.image.retain.url
end
