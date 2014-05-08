json.id reply.to_param
json.body reply.body
json.nickname reply.nickname
json.created_at reply.created_at

replyable_class = reply.replyable_type.constantize.new
json.replyable_id EncryptedId.encrypt(replyable_class.encrypted_id_key, reply.replyable_id)
json.replyable_type reply.replyable_type
json.replyable_body reply.replyable.body

if reply.topic_id
  json.topic_id EncryptedId.encrypt(Topic.encrypted_id_key, reply.topic_id)
end

if reply.member
  json.member do
    json.partial! "members/member", member: reply.member
  end
end
unless reply.replies.size.zero?
  json.replies reply.replies do |reply|
    json.partial! "replies/reply", reply: reply
  end
end
