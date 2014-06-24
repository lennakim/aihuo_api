json.advertisements @advertisements do |advertisement|
  json.id advertisement.id
  json.title advertisement.title
  json.banner advertisement.carrierwave_material(nil, :banner)
  json.url advertisement.carrierwave_material(nil, :url)
  json.apk_sign advertisement.apk_sign
end
json.tactics @tactics, :id, :action, :value
