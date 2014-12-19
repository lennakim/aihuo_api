module ProductsHelper
  extend Grape::API::Helpers

  params :products do
    optional :id, type: Array, desc: "Product ids."
    optional :tag, type: String, desc: "Tag name or keyword."
    optional :tags, type: Array, desc: "Categroy and brand."
    optional :match, type: String, default: "any", desc: "Match filter type."
    optional :min_price, type: String, desc: "Min price."
    optional :max_price, type: String, desc: "Max price."
    optional :register_date, type: String, desc: "Date looks like '20130401'."
    optional :sku_visible, type: Virtus::Attribute::Boolean, default: false, desc: "Return skus or not."
    optional :page, type: Integer, desc: "Page number."
    optional :per_page, type: Integer, default: 10, desc: "Per page value."
    optional :sort, type: Symbol, values: [:tag, :rank, :volume, :price, :newly], default: :tag
    optional :order, type: Symbol, values: [:desc, :asc], default: :desc
  end

  params :trades do
    optional :filter, type: Symbol, values: [:rated, :all], default: :all, desc: "Filtering trades with commented or not."
    optional :page, type: Integer, desc: "Page number."
    optional :per_page, type: Integer, default: 10, desc: "Per page value."
  end

  def query_params
    # 传递的是二级分类过滤器中的 category 和 brand
    if params[:tags]
      params[:match] = "match_all"
      params[:tags].inject([]) do |tags, tag|
        tags << tag
      end
    # 传递的是一个 tag 或者搜索关键词
    elsif params[:tag]
      tag = Tag.find_by(name: params[:tag])
      if tag
        tag = tag.self_and_descendants.collect(&:name)
        tag = tag[0] if tag.size == 1 # 如果 tag 数组只有一个元素
      end
      tag || params[:tag]
    # 传递的是一组产品ID
    elsif params[:id]
      params[:id].inject([]) do |ids, id|
        ids << Product.decrypt(Product.encrypted_id_key, id).to_i
      end
    end
  end

  def date_param
    date = request.headers["Registerdate"] || params[:register_date]
    date.to_date if date
  end

  def product_cache_key
    [:v2, :product, params[:id]].join("-")
  end

  def products_cache_key
    [:v2, :products, params[:id], params[:tag], params[:tags], params[:match],
    params[:min_price], params[:max_price], params[:register_date],
    params[:sku_visible], params[:page], params[:per_page], params[:sort], params[:order]].join("-")
  end

  def trades_cache_key
    [:v2, :product, params[:id], :trades, params[:page], params[:per_page]].join("-")
  end
end
