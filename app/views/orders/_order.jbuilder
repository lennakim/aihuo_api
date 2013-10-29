json.number order.number
json.id order.to_param
json.pay_type order.pay_type
json.total order.total
json.state order.state
json.created_at order.created_at.strftime("%F %T")
