json.id product.to_param
json.title product.title
json.market_price product.market_price.to_f
json.retail_price product.retail_price.to_f
json.labels product.labels
json.out_of_stock product.out_of_stock
