json.banners @banners do |article|
  json.id article.to_param
  json.title article.title
  json.background do
    json.ipad article.background.ipad.url
    json.iphone article.background.iphone.url
    json.android article.background.android.url
  end
end
