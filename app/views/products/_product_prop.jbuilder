json.id product_prop.to_param
json.name product_prop.name
json.value product_prop.values
json.market_price product_prop.purchase_price.to_f
json.retail_price product_prop.sale_price.to_f
json.out_of_stock product_prop.out_of_stock
