json.id topic_image.to_param
json.image do
  # json.thumb topic_image.image_url(:thumb)
  # json.file topic_image.image_url
  json.thumb topic_image.format_image_url
  json.file topic_image.format_image_url
end
