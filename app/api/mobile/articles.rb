module Mobile
  class Articles < Grape::API
    resources 'articles' do
      desc "Return a public timeline, my first api."
      get :public_timeline, jbuilder: 'articles/public_timeline' do
        @articles = Article.limit(25)
      end

      desc "Return an article."
      get ':id', jbuilder: 'articles/article' do
        @article = Article.find(params[:id])
      end
    end
  end
end
