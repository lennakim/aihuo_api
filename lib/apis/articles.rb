class Articles < Grape::API
  helpers do
    def date_param
      date = request.headers["Registerdate"] || params[:register_date]
      date.to_date if date
    end
  end

  resources 'articles' do

    desc "Listing articles."
    params do
      optional :filter, type: Symbol, values: [:healthy, :all], default: :all, desc: "Filtering for blacklist."
      optional :register_date, type: String, desc: "Date looks like '20130401'."
      optional :page, type: Integer, desc: "Page number."
      optional :per_page, type: Integer, default: 10, desc: "Per page value."
    end
    get "/", jbuilder: 'articles/articles' do
      articles =
        case params[:filter]
        when :healthy
          Article.available.healthy
        when :all
          Article.available.search(date_param, Date.today)
        end
      @articles = paginate(articles)
    end

    desc "Return an article."
    params do
      requires :id, type: String, desc: "Article ID."
    end
    get ':id', jbuilder: 'articles/article' do
      @article = Article.find(params[:id])
      cache(key: [:v2, :article, @article], expires_in: 2.days) do
        @article
      end
    end
  end
end
