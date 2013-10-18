json.id article.to_param
json.image do
  json.iphone article.background.iphone.url
end
json.title article.title
json.reading_count article.reading_count
json.created_at article.created_at
