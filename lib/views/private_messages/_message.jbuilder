json.id message.to_param
json.receiver_id EncryptedId.encrypt(Member.encrypted_id_key, message.receiver_id)
json.sender_id EncryptedId.encrypt(Member.encrypted_id_key, message.sender_id)
json.body message.body
json.opened message.opened
json.created_at message.created_at
