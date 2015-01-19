class Articles < Grape::API
  helpers do
    def date_param
      date = request.headers['Registerdate'] || params[:register_date]
      date.to_date if date
    end

    def hide_gift_products?
      date_param.blank? || date_param < 2.days.ago(Date.today)
    end
  end

  resources 'articles' do

    desc 'Listing articles.'
    params do
      optional :filter, type: Symbol, values: [:healthy, :all, :tags], default: :all, desc: 'Filtering for blacklist.'
      optional :filter_value, type: String, desc: 'filter value'
      optional :register_date, type: String, desc: 'Date looks like 20130401.'
      optional :page, type: Integer, desc: 'Page number.'
      optional :per_page, type: Integer, default: 10, desc: 'Per page value.'
    end
    get '/', jbuilder: 'articles/articles' do
      articles =
        case params[:filter]
        when :healthy
          Article.available.healthy
        when :all
          Article.available.search(date_param, Date.today)
        when :tags
          Article.tagged_with(params[:filter_value], any: true)
        end
      if hide_gift_products?
        @articles = paginate(articles.without_gifts)
      else
        @articles = paginate(articles)
      end
    end

    desc 'Return an article.'
    params do
      requires :id, type: String, desc: 'Article ID.'
    end
    get ':id', jbuilder: 'articles/article' do
      cache(key: [:v2, :article, params[:id]], expires_in: 4.hours) do
        @article = Article.find(params[:id])
      end
    end
  end
end
