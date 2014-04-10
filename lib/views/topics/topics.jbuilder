json.topics @topics do |topic|
  json.partial! "topics/topic", topic: topic
end
