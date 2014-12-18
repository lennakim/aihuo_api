json.configurations @configurations.each do |configuration|
  json.type configuration["name"]
  json.transport_price configuration[:transport_price.to_s].to_f.round(2)
  json.transport_free_price configuration[:transport_free_price.to_s].to_f.round(2)
  json.transport_description configuration[:transport_description.to_s]
end
