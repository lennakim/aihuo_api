require "test_helper"

class ProductTest < ActiveSupport::TestCase
  def test_search_by_tag_without_children
    assert_equal 10, Product.search("情趣内衣", nil, Date.today, "any").length
  end

  def test_search_by_tag_with_children
    assert_equal 50, Product.search("男用", nil, Date.today, "any").length

    tag = Tag.find_by(name: "女用")
    tag = tag.self_and_descendants.collect(&:name)
    assert_equal 30, Product.search(tag, nil, Date.today, "any").length
  end

  def test_product_recommend_tags_without_children
    product = Product.find_by(id: 71)
    assert_equal 2, product.recommend_list.size
  end

  def test_product_recommend_tags_with_children
    product = Product.find_by(id: 71)
    # product.send(:recommend_tag_with_children) shoulde be [["玩具", "电动飞机", "电动汽车"], ["食品"]]
    assert_equal 2, product.send(:recommend_tag_with_children).size
    assert_equal 3, product.send(:recommend_tag_with_children).first.size
  end

  def test_serach_by_keyword
    tags = ["玩具", "电动飞机", "电动汽车"]
    assert_equal 10, Product.serach_by_keyword(tags, "any").length
  end

  # 无法测试，因为 order by field 是一个 mysql 函数
  # def test_order_by_sales_volumes
  #   tags = ["玩具", "电动飞机", "电动汽车"]
  #   assert_equal 10, Product.serach_by_keyword(tags, "any").order_by_sales_volumes
  # end

  # 无法测试，因为 order by field 是一个 mysql 函数
  # def test_sort_by_tag
  #   products = Product.search("男用", nil, Date.today, "any")
  #   assert_equal 3, products.sort_by_tag_name("男用").first.id
  # end
  #测试product banner传入安全参数后返回健康内容
  def test_product_banners_healthy
    assert_equal 5, Product.healthy.banner.length
  end
#以下为新功能tab页测试
  #测试rank排序
  def test_sorted_by_sort_order_rank
    products = Product.search("情趣内衣", nil, Date.today, "any").sort_by_sort_order(:rank, :desc)
    a,b = rand(products.length-1),rand(products.length-1)
    a,b = b,a if a > b
    assert_equal true, products[a].rank >= products[b].rank
  end
  #测试上架时间created_at排序
  def test_sorted_by_sort_order_newly
    products = Product.search("情趣内衣", nil, Date.today, "any").sort_by_sort_order(:newly, :desc)
    a,b = rand(products.length-1),rand(products.length-1)
    a,b = b,a if a > b
    assert_equal true, products[a].created_at >= products[b].created_at
  end
  #测试价格price排序
  def test_sorted_by_sort_order_price
    products = Product.search("情趣内衣", nil, Date.today, "any").sort_by_sort_order(:price, :desc)
    a,b = rand(products.length-1),rand(products.length-1)
    a,b = b,a if a > b
    assert_equal true, products[a].retail_price.to_i >= products[b].retail_price.to_i
  end
  # 无法测试，因为 order by field 是一个 mysql 函数
  #测试周销量排序
  # def test_sorted_by_sort_order_price
    # products = Product.search("情趣内衣", nil, Date.today, "any").sorted_by_sort_order(:volume, :desc)
    # a,b = rand(products.length-1),rand(products.length-1)
    # a,b = b,a if a > b
  # end
end
