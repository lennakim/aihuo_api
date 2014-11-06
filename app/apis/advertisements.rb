class Advertisements < Grape::API
  helpers MemcachedHelper

  resources 'advertisements' do
    params do
      requires :id, type: String, desc: 'Advertisement ID.'
    end
    route_param :id do
      desc 'Change advertisement info.'
      params do
        requires :action, type: Symbol, values: [:view, :read, :click, :install], desc: 'Action Name.'
        requires :device_id, type: String, desc: 'Device ID.'
      end
      put '/' do
        current_application
        key = "#{Date.today}:#{@application.id}:#{params[:id]}:#{params[:action]}"
        incr_value_in_memcached('statistic_keys', key)
        status 200
      end
    end
  end
end
