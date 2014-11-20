json.comment do
  json.id comment.to_param
  json.nick comment.name
  json.content comment.content
  json.quality  (comment.score ? comment.score : Comment::DEFAULT_SCORE
  json.logistics_value logistics_value
  json.created_at comment.comment_at
end
