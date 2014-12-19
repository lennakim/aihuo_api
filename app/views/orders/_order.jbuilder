json.ignore_nil!
json.number order.number
json.id order.to_param
json.pay_type order.pay_type
json.total order.total
json.state order.state
json.operation_code order.operation_code
json.express_number order.express_number
json.express_company order.express_company
json.zero_msg order.message
# json.created_at order.created_at.strftime("%F %T")
json.created_at order.created_at
