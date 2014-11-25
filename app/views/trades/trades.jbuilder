json.trades @trades do |trade|
  json.id trade.to_param
  json.province trade.shipping_province
  json.city trade.shipping_city
  json.district trade.shipping_district
  json.created_at trade.commented_at
  comment = trade.line_item_commments.find_by(product_id: @product_id)
  comment ||= trade.comments.try(:first)
  if comment
    json.partial! "trades/comment", comment: comment
    json.logistics_score trade.logistics_score
  end
end
