json.topics @topics do |topic|
  json.partial! "topics/topic", topic: topic
end
json.current_page @topics.current_page
json.total_pages @topics.total_pages
json.total_count @topics.total_count
