class Coupons < Grape::API
  helpers CouponsHelper

  resources 'coupons' do
    desc "Listing coupons of a device."
    params do
      use :coupons
    end
    get '/', jbuilder: 'coupons/coupons' do
      current_application
      coupons = @application.coupons.by_sdk_ver(params[:sdk_ver])
      coupons = coupons.available.by_device(params[:device_id])
      @coupons = paginate(coupons)
    end
  end
end
