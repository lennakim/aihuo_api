json.id reply.to_param
json.body reply.body
json.nickname reply.nickname
json.created_at reply.created_at
unless reply.replies.size.zero?
  json.replies reply.replies do |reply|
    json.partial! "replies/reply", reply: reply
  end
end
