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

json.submenus @submenus, :id, :type, :title, :name, :image

json.sections @sections do |section|
  json.name section[0].name
  json.objects section[1..6], :id, :type, :title, :image
end

json.categories @categories, :id, :type, :title, :name, :image

json.brands @brands, :id, :type, :title, :image
