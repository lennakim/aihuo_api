class Articles < Grape::API
  resources 'articles' do

    desc "Listing articles."
    params do
      optional :page, type: Integer, desc: "Page number."
      optional :per, type: Integer, default: 10, desc: "Per page value."
    end
    get "/", jbuilder: 'articles/articles' do
      @articles = Article.page(params[:page]).per(params[:per])
    end

    desc "Return an article."
    params do
      requires :id, type: String, desc: "Article ID."
    end
    get ':id', jbuilder: 'articles/article' do
      @article = Article.find(params[:id])
    end
  end
end
