if @topic.invalid?
  json.error @topic.errors.values[0][0]
else
  json.partial! "topics/topic", topic: @topic
end

