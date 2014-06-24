json.messages @private_messages do |message|
  json.partial! "private_messages/message", message: message
end
