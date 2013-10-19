json.messages @messages do |message|
  json.id message.id
  json.object_id message.object_id
  json.from message.from
  json.category message.category
  json.body message.body
end
json.current_page @messages.current_page
json.total_pages @messages.total_pages
json.total_count @messages.total_count
