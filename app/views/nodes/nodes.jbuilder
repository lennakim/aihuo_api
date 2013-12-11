json.nodes @nodes do |node|
  json.id node.to_param
  json.name node.name
  json.summary node.summary
  json.sort node.sort
  json.topics_count node.topics_count
end
