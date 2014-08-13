json.advertisements @advertisements do |advertisement|
  json.id advertisement.id
  json.title advertisement.title
  json.description advertisement.description
  json.icon advertisement.carrierwave_material(nil, :icon)
  json.banner advertisement.carrierwave_material(nil, :banner)
  if advertisement.square_banner
    json.square_banner advertisement.carrierwave_material(nil, :square_banner)
  end
  json.url advertisement.carrierwave_material(nil, :url)
  json.apk_sign advertisement.apk_sign
end
# json.tactics @tactics, :id, :action, :value, :notice_type, :adv_content_id
json.tactics @tactics do |tractic|
  json.id tractic.id
  json.action tractic.action
  json.value tractic.value
  json.notice_type tractic.notice_type
  json.advertisement_ids tractic.adv_content_ids if tractic.adv_content_ids && !tractic.adv_content_ids.size.zero?
end
