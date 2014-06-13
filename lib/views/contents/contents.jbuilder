json.contents @contents do |content|
  json.partial! "contents/content", content: content
end
