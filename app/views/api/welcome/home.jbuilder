json.banners @banners do |article|
  json.id article.to_param
  json.title article.title
  json.image article.background
end
