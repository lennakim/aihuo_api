module ArticleFormatter
  extend ActiveSupport::Concern

  included do
    # 过滤编辑的文章内容，让新版旧版的文章内部连接可以返回适配iOS的数据
    # 例如：
    # <a href="185?mobile=1">test</a> 改为:
    # <a href="articles?5592f518373333f6a0a3b30a20b6a2b9">test</a>
    #
    # <img alt="" onclick="javascript:return window.adultshop.openProduct(3392)"
    #   src="/system/ckeditor_assets/pictures/631/content_9-1___.jpg"
    #   style="width: 450px; height: 166px;" /> 改为:
    # <a href="products?b8618303e2e90a25d868609258c5c21d"><img ... /></a>
    #
    def body
      content = read_attribute(:body)

      article_ids = []
      product_ids = []

      article_pattern = /(href=")(?<id>\d+)(\?mobile=1")/
      product_pattern = /(adultshop.openProduct\()(?<id>\d+)(\)")/

      content.scan(article_pattern) { |result| article_ids << result[0] }
      content.scan(product_pattern) { |result| product_ids << result[0] }

      article_ids.each do |id|
        encrypted_id = EncryptedId.encrypt(Article.encrypted_id_key, id)
        content.gsub!("#{id}?mobile=1", "articles?#{encrypted_id}")
      end

      product_ids.each do |id|
        reg = /<img [\S| ]+adultshop.openProduct\(#{id}\)[\S| ]+\/>/
        img = content.scan(reg)

        encrypted_id = EncryptedId.encrypt(Product.encrypted_id_key, id)
        text = "<a href=\"products?#{encrypted_id}\">" + img[0].to_s + "</a>"

        content.gsub!(reg, text)
      end

      content
    end
  end
end
