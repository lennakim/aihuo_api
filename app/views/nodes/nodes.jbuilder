json.nodes @nodes do |node|
  json.id node.to_param
  json.name node.name
  json.summary node.summary
  json.sort node.sort
  json.topics_count node.topics_count
end

json.current_page @nodes.current_page
json.total_pages @nodes.total_pages
json.total_count @nodes.total_count
