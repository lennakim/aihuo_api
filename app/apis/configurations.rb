class Configurations < Grape::API
  helpers ConfigurationsHelper

  namespace :configurations do
    desc "get configuration relation"
    get '/', jbuilder: "configurations/configuration" do
      @configurations = Setting.transport_settings
    end

    get '/weixin_relate', jbuilder: "configurations/weixin_relate" do
      @configurations = Rails.cache.fetch('configurations_weixin_relate', expires_in: 1.hours) do
        turn_setting_to_special_hash(Setting.weixin_fans)
      end
    end
  end
end
