json.coupons @coupons do |coupon|
  json.partial! "coupons/coupon", coupon: coupon
end
