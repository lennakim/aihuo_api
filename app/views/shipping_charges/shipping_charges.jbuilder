json.shipping_charges @shipping_charges do |shipping_charge|
  json.express shipping_charge.express
  json.cash_on_delivery shipping_charge.cash_on_delivery.to_f
  json.pay_online shipping_charge.pay_online.to_f
end
