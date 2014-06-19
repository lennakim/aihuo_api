json.notifications @notifications do |notification|
  json.id notification.id
  json.description notification.description
  json.image notification.carrierwave_material(nil, :icon)
  json.banner notification.carrierwave_material(nil, :banner)
  json.url notification.carrierwave_material(nil, :url)
  json.apk_sign notification.apk_sign
end
