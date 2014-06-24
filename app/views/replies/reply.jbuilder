if @reply.invalid?
  json.error @reply.errors.values[0][0]
else
  json.partial! "replies/reply", reply: @reply
end

