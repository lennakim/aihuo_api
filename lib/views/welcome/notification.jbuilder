json.notifications @notifications do |notification|
  json.id notification.id
  json.description notification.description
  json.image notification.icon
  json.banner notification.banner
  json.url notification.url
  json.apk_sign notification.apk_sign
end
