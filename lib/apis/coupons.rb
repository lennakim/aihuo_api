class Coupons < Grape::API
  resources 'coupons' do

    desc "Listing coupons of a device."
    params do
      requires :device_id, type: String, desc: "Device ID"
      optional :sdk_ver, type: String, desc: "channel name"
      optional :page, type: Integer, desc: "Page number."
      optional :per_page, type: Integer, default: 10, desc: "Per page value."
    end
    get '/', jbuilder: 'coupons/coupons' do
      current_application
      coupons =
        if params[:sdk_ver]
          @application.coupons.by_sdk_ver(params[:sdk_ver])
        else
          Coupon.where(application_id: nil)
        end
      coupons = coupons.available.by_device(params[:device_id])
      @coupons = paginate(coupons)
    end

  end
end
