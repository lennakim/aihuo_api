json.transport @transports.each do |transport|
  json.type transport["name"]
  json.transport_price transport[:transport_price.to_s].to_f.round(2)
  json.transport_free_price transport[:transport_free_price.to_s].to_f.round(2)
  json.transport_description transport[:transport_description.to_s]
end
