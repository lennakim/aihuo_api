class Configurations < Grape::API

  namespace :configurations do
    params do
      requires :id, type: String, desc: "setting key"
    end
    route_param :id do

      before do
        begin
          @setting = Setting.find_by_name(params[:id])
          error! "configuration not found", 404 unless @setting
        rescue Exception => e
          error! "configuration not found", 404
        end
      end

      desc "get configuration relation"
      params do
      end
      get '/', jbuilder: "configurations/transport" do
        @transports = case params[:id].to_sym
                      when :online_pay, :offline_pay
                        Setting.turn_transport_format([@setting])
                      when :transport
                        setting_keys = @setting.value.split("|")
                         Setting.turn_transport_format(Setting.where(name: setting_keys))
                      else
                        error! "configuration permit", 404
                      end
      end
    end
  end
end
