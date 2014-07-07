class Advertisements < Grape::API
  resources 'advertisements' do
    params do
      requires :id, type: String, desc: "Advertisement ID."
    end
    route_param :id do
      desc "Change advertisement info."
      params do
        requires :action, type: Symbol, values: [:view, :click, :install], desc: "Action Name."
        requires :device_id, type: String, desc: "Device ID."
      end
      put "/" do
        current_application
        AdvStatistic.increase_count(
          @application.id,
          params[:id],
          params[:action]
        )
      end
    end
  end
end
