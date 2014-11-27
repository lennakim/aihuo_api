json.comment do
  json.id comment.to_param
  json.nick comment.name
  json.content comment.content
  json.created_at comment.comment_at
  json.product_quality_score comment.product_quality_score
  json.express_score comment.express_score
end
