class Articles < Grape::API
  resources 'articles' do

    desc "Listing articles."
    params do
      optional :page, type: Integer, desc: "Page number."
      optional :per_page, type: Integer, default: 10, desc: "Per page value."
    end
    get "/", jbuilder: 'articles/articles' do
      @articles = paginate(Article.available)
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
