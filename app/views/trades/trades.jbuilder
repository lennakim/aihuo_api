json.trades @trades do |trade|
  json.id trade.to_param
  json.province trade.shipping_province
  json.city trade.shipping_city
  json.district trade.shipping_district
  json.created_at trade.commented_at
  comment = trade.comment_by_product(@product)
  if comment
    json.partial! "trades/comment", comment: comment
    json.express_score trade.express_score
  end
end
