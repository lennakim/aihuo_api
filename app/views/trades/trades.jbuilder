json.trades @trades do |trade|
  json.id trade.to_param
  json.province trade.shipping_province
  json.city trade.shipping_city
  json.district trade.shipping_district
  json.created_at trade.created_at
  unless trade.comments.size.zero?
    json.partial! "trades/comment", comment: trade.comments.first
  end
end
json.current_page @trades.current_page
json.total_pages @trades.total_pages
json.total_count @trades.total_count
