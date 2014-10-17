json.nodes @nodes do |node|
  json.cache! node.cache_key, expires_in: 4.hours do
    json.partial! "nodes/node", node: node
  end
end

