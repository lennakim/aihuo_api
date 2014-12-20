class DeviceInfos < Grape::API
  helpers do
    def current_device_info
      current_application
      @device_info = DeviceInfo.where(
        device_id: params[:device_id],
        application_id: @application.id,
        baidu_user_id: params[:device_info][:baidu_user_id],
        baidu_channel_id: params[:device_info][:baidu_channel_id]
      ).first_or_create!
    end

    def device_info_params
      declared(params, include_missing: false)[:device_info]
    end
  end

  resources 'device_infos' do
    desc "Create a device info about baidu sdk."
    params do
      requires :device_id, type: String, desc: "Device ID"
      optional :api_key, type: String, desc: "Application API Key"
      requires :sign, type: String, desc: "Sign value"
      group :device_info, type: Hash do
        requires :baidu_user_id, type: String
        requires :baidu_channel_id, type: String
      end
    end
    post '/', jbuilder: 'device_infos/device_info' do
      if sign_approval?
        current_device_info
        status 500 unless @device_info
        if @device_info && @device_info.created_at > 5.minutes.ago
          Notification.send_visit_website_msg(@device_info.device_id, @device_info.application_id)
        end
      else
        error! "Access Denied", 401
      end
    end
  end
end
