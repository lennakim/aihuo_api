module API
  class DeviceInfos < Grape::API
    helpers do
      def device_info_params
        current_application
        params[:device_info][:device_id] = params[:device_id]
        params[:device_info][:application_id] = @application.id
        declared(params, include_missing: false)[:device_info]
      end
    end

    resources 'device_infos' do
      desc "Create a device info about baidu sdk."
      params do
        requires :device_id, type: String, desc: "Device ID"
        requires :api_key, type: String, desc: "Application API Key"
        group :device_info do
          requires :baidu_user_id, type: String
          requires :baidu_channel_id, type: String
          optional :device_id, type: String, desc: "Device ID"
          optional :application_id, type: Integer, desc: "Application ID"
        end
      end
      post '/', jbuilder: 'device_infos/device_info' do
        @device_info = DeviceInfo.create!(device_info_params)
      end
    end
  end
end
