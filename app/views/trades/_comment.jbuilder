json.comment do
  json.ignore_nil!
  json.id comment.to_param
  json.content comment.content
  json.created_at comment.comment_at
  json.product_quality_score comment.product_quality_score
  json.express_score comment.express_score
end
