json.trades @trades do |trade|
  json.cache! trade.cache_key, expires_in: 1.hours do
    json.id trade.to_param
    json.province trade.shipping_province
    json.city trade.shipping_city
    json.district trade.shipping_district
    json.created_at trade.created_at
    comment = trade.comment_by_product(@product)
    if comment
      json.partial! "trades/comment", comment: comment
    end
  end
end
