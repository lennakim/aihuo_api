class Tabs < Grape::API
  helpers TabsHelper
  resources 'tabs' do
    desc "Listing tab page for app."
    get "/", jbuilder: 'tags/tags' do
      cache(key: tabs_cacke_key, expires_in: 30.minutes) do
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