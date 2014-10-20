json.banners @banners do |banner|
  json.id banner.to_param
  json.title banner.title
  json.type banner.class.name
  if banner.background
    json.background do
      json.default banner.carrierwave_background(nil, :url)
      json.ipad banner.carrierwave_background(:ipad, :url)
      json.iphone banner.carrierwave_background(:iphone, :url)
      json.android banner.carrierwave_background(:android, :url)
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
