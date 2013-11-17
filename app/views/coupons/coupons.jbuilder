json.coupons @coupons do |coupon|
  json.partial! "coupons/coupon", coupon: coupon
end
json.current_page @coupons.current_page
json.total_pages @coupons.total_pages
json.total_count @coupons.total_count
