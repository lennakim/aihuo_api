json.articles @articles do |article|
  json.partial! "articles/article", article: article
end
