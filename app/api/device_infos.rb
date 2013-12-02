module API
  class DeviceInfos < Grape::API
    helpers do
      def current_device_info
        current_application
        @device_info = DeviceInfo.where(device_id: params[:device_id], application_id: @application.id).first_or_create!
      end

      def device_info_params
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
        end
      end
      post '/', jbuilder: 'device_infos/device_info' do
        if sign_approval?
          current_device_info
          status 500 unless @device_info.update_attributes(device_info_params)
        else
          error! "Access Denied", 401
        end
      end
    end
  end
end
