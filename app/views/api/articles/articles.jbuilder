json.articles @articles do |article|
  json.partial! "articles/article", article: article
end
json.current_page @articles.current_page
json.total_pages @articles.total_pages
json.total_count @articles.total_count
