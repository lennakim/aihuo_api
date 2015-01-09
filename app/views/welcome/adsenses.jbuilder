json.advertisements @advertisements do |advertisement|
  json.cache! advertisement.cache_key, expires_in: 1.hours do
    json.id advertisement.id
    json.(advertisement, :title, :description, :url, :apk_sign)
    json.icon advertisement.carrierwave_material(nil, :icon)
    json.banner advertisement.carrierwave_material(nil, :banner)
    if advertisement.square_banner
      json.square_banner advertisement.carrierwave_material(nil, :square_banner)
    end
  end
end
json.tactics @tactics do |tractic|
  json.cache! tractic.cache_key, expires_in: 5.minutes do
    json.(tractic, :id, :action, :value, :notice_type)
    if tractic.adv_content_ids && !tractic.adv_content_ids.size.zero?
      json.advertisement_ids tractic.adv_content_ids
    end
  end
end
