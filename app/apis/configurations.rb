class Configurations < Grape::API

  namespace :configurations do
    params do
      requires :id, type: String, desc: "setting key"
    end
    route_param :id do

      before do
        @setting = Setting.find_by_name(params[:id])
        error! "configuration not found", 404 unless @setting
      end

      desc "get configuration relation"
      params do
      end
      get '/', jbuilder: "configurations/transport" do
        @transports = Setting.transport_setting(@setting)
      end
    end
  end
end
