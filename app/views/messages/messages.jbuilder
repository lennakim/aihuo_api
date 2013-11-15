json.messages @messages do |message|
  json.partial! "messages/message", message: message
end
json.current_page @messages.current_page
json.total_pages @messages.total_pages
json.total_count @messages.total_count
