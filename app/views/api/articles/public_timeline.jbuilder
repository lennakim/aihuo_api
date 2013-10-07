json.articles @articles do |article|
  json.id article.to_param
  json.image article.image_url if article.image
  json.title article.title
  json.reading_count article.reading_count
  json.created_at article.created_at
end
