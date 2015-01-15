json.configurations do
  @configurations.each {|key, value| json.set! key, value}
end
