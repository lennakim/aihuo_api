json.id message.to_param
json.parent_id message.question_id if message.parent_id
json.object_id message.product_id if message.object_id
json.from message.from
json.body message.body
json.created_at message.created_at
