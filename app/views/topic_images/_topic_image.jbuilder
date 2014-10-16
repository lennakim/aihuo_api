json.id topic_image.to_param
json.image do
  json.thumb topic_image.image_url
  json.file topic_image.image_url
end
