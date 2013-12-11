class Coupons < Grape::API
  resources 'coupons' do

    desc "Listing coupons of a device."
    params do
      requires :device_id, type: String, desc: "Device ID"
      optional :page, type: Integer, desc: "Page number."
      optional :per_page, type: Integer, default: 10, desc: "Per page value."
    end
    get '/', jbuilder: 'coupons/coupons' do
      @coupons = paginate(Coupon.validity.by_device(params[:device_id]))
    end

  end
end
