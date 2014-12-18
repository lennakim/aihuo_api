class Configurations < Grape::API

  namespace :configurations do
    desc "get configuration relation"
    get '/', jbuilder: "configurations/configuration" do
      @configurations = Setting.transport_settings
    end
  end
end
