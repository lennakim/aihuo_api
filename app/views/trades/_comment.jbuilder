json.comment do
  json.id comment.to_param
  json.nick comment.name
  json.content comment.content
  json.created_at comment.comment_at
  json.score comment.handled_score
end
