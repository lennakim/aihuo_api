json.comment do
  json.id comment.to_param
  json.nick comment.name
  json.content comment.content
  json.score comment.handled_score
end
