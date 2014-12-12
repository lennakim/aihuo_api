class Tags < Grape::API
  resources 'tags' do
    desc "Listing tags or popular search."
    params do
      optional :tag, type: String, default: "popular_search", desc: "tag name."
    end
    get "/", jbuilder: 'tags/tags' do
      @tag = Setting.find_by(name: params[:tag])
    end
  end
end
