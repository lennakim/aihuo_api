module API
  class Devices < Grape::API
    helpers do
      def current_device
        @device = Device.where(device_id: params[:device_id]).first_or_create!
      end

      def device_params
        declared(params, include_missing: false)[:device]
      end
    end

    resources 'devices' do
      desc "Create a device."
      params do
        requires :device_id, type: String, desc: "Device ID"
        group :device do
          optional :device_id, type: String
          optional :model_ver, type: String
          optional :manufacture, type: String
          optional :firmware, type: String
          optional :sdk_ver, type: String
          optional :apn, type: String
          optional :lang, type: String
          optional :country, type: String
          optional :channel_id, type: String
          optional :applist_md5, type: String
          optional :applist, type: String
          optional :location_info, type: String
          optional :address, type: String
          optional :init_app_ver, type: String
          optional :app_ver, type: String
          optional :devinfo_extra, type: String
        end
      end
      post '/', jbuilder: 'devices/device' do
        current_device
        @device.update_attributes(device_params)
      end
    end
  end
end
