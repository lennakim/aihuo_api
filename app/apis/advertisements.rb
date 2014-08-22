class Advertisements < Grape::API
  resources 'advertisements' do
    params do
      requires :id, type: String, desc: "Advertisement ID."
    end
    route_param :id do
      desc "Change advertisement info."
      params do
        requires :action, type: Symbol, values: [:view, :read, :click, :install], desc: "Action Name."
        requires :device_id, type: String, desc: "Device ID."
      end
      put "/" do
        current_application
        key = "#{Date.today}:#{@application.id}:#{params[:id]}:#{params[:action]}"
        Rails.cache.dalli.with do |client|
          if client.add(key, 1, 0, raw: true)
            client.append('statistic_keys', ",#{key}") unless client.add('statistic_keys', key, 0, raw: true)
          else
            client.incr key
          end
        end
        status 200
      end
    end
  end
end
