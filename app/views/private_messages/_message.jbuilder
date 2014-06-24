json.id message.to_param
json.receiver_id Member.encrypt(Member.encrypted_id_key, message.receiver_id)
json.body message.body
json.opened message.opened
json.created_at message.created_at

if message.sender
  json.member do
    json.partial! "members/member", member: message.sender
  end
end
