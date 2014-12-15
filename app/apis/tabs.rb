class Tabs < Grape::API
  helpers TabsHelper
  resources 'tabs' do
    desc "Listing tab page for app."
    get "/", jbuilder: 'tabs/tabs' do
      cache(key: tabs_cacke_key, expires_in: 30.minutes) do
        begin
          current_application
          homepage = Homepage.for_app_tabs(@application)
        rescue Exception => e
          error! "app tab page not found", 404
        end
        @tabs = homepage.contents
      end
    end
  end
end