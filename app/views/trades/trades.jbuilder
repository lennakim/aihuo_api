json.trades @trades do |trade|
  json.id trade.to_param
  json.province trade.shipping_province
  json.city trade.shipping_city
  json.district trade.shipping_district
  json.created_at trade.commented_at
  comment = trade.comment_by_product_id(@product_id)
  comment ||= trade.comments.try(:first)
  if comment
    json.partial! "trades/comment", comment: comment
    json.logistics (trade.order_comment ? trade.order_comment.handled_score : Comment::DEFAULT_SCORE)
  end
end
