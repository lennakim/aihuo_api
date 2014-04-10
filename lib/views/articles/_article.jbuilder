json.id article.to_param
if article.background
  json.image do
    json.iphone article.carrierwave_background(:iphone, :url)
  end
end
json.title article.title
json.reading_count article.reading_count
json.created_at article.created_at
