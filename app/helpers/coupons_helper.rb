module CouponsHelper
  extend Grape::API::Helpers

  params :coupons do
    requires :device_id, type: String, desc: "Device ID"
    optional :sdk_ver, type: String, desc: "channel name"
    optional :page, type: Integer, desc: "Page number."
    optional :per_page, type: Integer, default: 10, desc: "Per page value."
  end
end
