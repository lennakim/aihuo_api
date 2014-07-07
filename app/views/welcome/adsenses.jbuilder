json.advertisements @advertisements do |advertisement|
  json.id advertisement.id
  json.title advertisement.title
  json.banner advertisement.carrierwave_material(nil, :banner)
  if advertisement.square_banner
    json.square_banner advertisement.carrierwave_material(nil, :square_banner)
  end
  json.url advertisement.carrierwave_material(nil, :url)
  json.apk_sign advertisement.apk_sign
end
json.tactics @tactics, :id, :action, :value, :notice_type
