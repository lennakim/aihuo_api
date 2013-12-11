json.replies @replies do |reply|
  json.partial! "replies/reply", reply: reply
end
