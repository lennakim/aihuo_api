json.articles @articles do |article|
  json.partial! "articles/article", article: article
end
json.total_number @total_number
