json.shipping_charges @shipping_charges do |shipping_charge|
  json.express shipping_charge.express
  json.cash_on_delivery shipping_charge.cash_on_delivery
  json.pay_online shipping_charge.pay_online
end
