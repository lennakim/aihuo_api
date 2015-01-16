class Configurations < Grape::API

  namespace :configurations do
    desc "get configuration relation"
    get '/', jbuilder: "configurations/configuration" do
      @configurations = Setting.transport_settings
    end

    get '/weixin_relate', jbuilder: "configurations/weixin_relate" do
      @configurations = Setting.weixin_fans.to_hash
    end
  end
end
