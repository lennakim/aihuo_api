json.banners @banners do |article|
  json.id article.to_param
  json.title article.title
  if article.background
    json.background do
      json.ipad article.carrierwave_background(:ipad, :url)
      json.iphone article.carrierwave_background(:iphone, :url)
      json.android article.carrierwave_background(:android, :url)
    end
  end
end
