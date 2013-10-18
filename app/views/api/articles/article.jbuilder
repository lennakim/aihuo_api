json.partial! "articles/article", article: @article
json.(@article, :body)
