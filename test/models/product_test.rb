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
  #   assert_equal 3, products.sorted_by_tag("男用").first.id
  # end
  #测试product banner传入安全参数后返回健康内容
  def test_product_banners_healthy
    assert_equal 5, Product.healthy.banner.length
  end
end
