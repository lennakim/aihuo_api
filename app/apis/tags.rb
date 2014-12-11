class Tags < Grape::API
  helpers TagsHelper
  resources 'tags' do
    desc "Listing tags or popular search."
    params do
      optional :tag, type: String, default: "popular_search", desc: "tag name."
    end
    get "/", jbuilder: 'tags/tags' do
      @tag = Setting.find_by(name: params[:tag])
    end
  end
  
  resources 'tab' do
    desc "Listing tab for app."
    get "/", jbuilder: 'tags/tags' do
      cache(key: tab_cacke_key, expires_in: 30.minutes) do
        begin
          current_application
          @homepage = Homepage.where("label = 'tab' and application_id = ?", @application.id).first
          rescue Exception => e
            error! "app tab page not found", 404
        end
        @tabs = @homepage.contents.where(typename: "Tag")
      end
    end
  end
end
