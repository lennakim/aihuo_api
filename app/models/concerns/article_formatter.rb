module ArticleFormatter
  extend ActiveSupport::Concern

  CKEDITOR_ASSETS_SERVER = "http://www.yepcolor.com"

  included do
    # step 1. 过滤编辑的文章内容，让新版旧版的文章内部连接可以返回适配iOS的数据
    # 例如：
    # <a href="185?mobile=1">test</a> 改为:
    # <a href="articles?5592f518373333f6a0a3b30a20b6a2b9">test</a>
    #
    # <img alt="" onclick="javascript:return window.adultshop.openProduct(3392)"
    #   src="/system/ckeditor_assets/pictures/631/content_9-1___.jpg"
    #   style="width: 450px; height: 166px;" /> 改为:
    # <a href="products?b8618303e2e90a25d868609258c5c21d"><img ... /></a>
    #
    # step 2. 过滤图片的 style 属性，设置为全屏宽
    #
    # step 3. 过滤编辑的文章内容，让 yepcolor 上的图片数据显示 url 而不是 path
    def body
      content = read_attribute(:body)

      # step 1
      article_ids = []
      product_ids = []

      article_pattern = /(href=")(?<id>\d+)(\?mobile=1")/
      product_pattern = /(adultshop.openProduct\()(?<id>\d+)(\)")/

      content.scan(article_pattern) { |result| article_ids << result[0] }
      content.scan(product_pattern) { |result| product_ids << result[0] }

      article_ids.each do |id|
        encrypted_id = Article.encrypt(Article.encrypted_id_key, id)
        content.gsub!("#{id}?mobile=1", "articles?#{encrypted_id}")
      end

      product_ids.each do |id|
        reg = /<img [\S| ]+adultshop.openProduct\(#{id}\)[\S| ]+\/>/
        img = content.scan(reg)

        encrypted_id = Product.encrypt(Product.encrypted_id_key, id)
        text = "<a href=\"products?#{encrypted_id}\">" + img[0].to_s + "</a>"

        content.gsub!(reg, text)
      end

      # step 2
      img_styles = []
      img_style_pattern = /(?<style>\"width:[\w| |;]+height:[\w| |;]+\")/
      content.scan(img_style_pattern) { |result| img_styles << result[0] }
      img_styles.each { |style| content.gsub!(style.to_s, "\"width:100%\"") }

      # step 3
      img_path_reg = "\"/system/ckeditor_assets/"
      img_url_text = "\"#{ArticleFormatter::CKEDITOR_ASSETS_SERVER}/system/ckeditor_assets/"
      content.gsub!(img_path_reg, img_url_text)

      content
    end
  end
end
