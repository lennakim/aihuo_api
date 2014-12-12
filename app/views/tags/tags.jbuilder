if @tag
  json.categories @tag.value.split("/")[0].split("|") if @tag.value.split("/")[0]
  json.brands @tag.value.split("/")[1].split("|") if @tag.value.split("/")[1]
  json.prices @tag.value.split("/")[2].split("|") if @tag.value.split("/")[2]
end
if @tabs
  json.tabs @tabs, :id, :type, :title, :name, :image
end
