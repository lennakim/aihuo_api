json.nodes @nodes do |node|
  json.cache! node.cache_key, expires_in: 4.hours do
    json.id node.to_param
    json.extract! node, :name, :summary, :sort, :topics_count, :rule
    json.icon node.carrierwave_icon(nil, :url) if node.icon
    json.rule node.rule if node.rule
  end
end
