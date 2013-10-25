json.replies @replies do |reply|
  json.partial! "replies/reply", reply: reply
end
json.current_page @replies.current_page
json.total_pages @replies.total_pages
json.total_count @replies.total_count
