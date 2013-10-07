module Mobile
  class Articles < Grape::API
    resources 'articles' do
      desc "Return a public timeline of articles."
      params do
        optional :page, type: Integer, desc: "Page number."
        optional :per, type: Integer, default: 10, desc: "Page number."
      end
      get :public_timeline, jbuilder: 'articles/public_timeline' do
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
end
