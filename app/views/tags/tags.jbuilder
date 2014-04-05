if @tag
  json.category @tag.value.split("/")[0] if @tag.value.split("/")[0]
  json.brand @tag.value.split("/")[1] if @tag.value.split("/")[1]
  json.price @tag.value.split("/")[2] if @tag.value.split("/")[2]
end
