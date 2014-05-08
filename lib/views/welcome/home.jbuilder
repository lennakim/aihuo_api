json.banners @banners do |article|
  json.id article.to_param
  json.title article.title
  if article.background
    json.background do
      json.default article.carrierwave_background(nil, :url)
      json.ipad article.carrierwave_background(:ipad, :url)
      json.iphone article.carrierwave_background(:iphone, :url)
      json.android article.carrierwave_background(:android, :url)
    end
  end
end

json.submenus @submenus

json.sections @sections do |section|
  json.name section[:name]
  json.objects section[:objects]
end

# json.categories @categories do |tag|
#   json.id tag.id
#   json.name tag.name
#   json.image tag.carrierwave_image(:thumb, :url) if tag.image
# end

json.categories @categories

json.brands @brands
