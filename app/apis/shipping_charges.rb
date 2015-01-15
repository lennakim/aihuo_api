class ShippingCharges < Grape::API
  resources 'shipping_charges' do
    desc 'Listing shipping charges.'
    params do
      optional :province, type: String
      optional :city, type: String
      optional :district, type: String
    end
    get '/', jbuilder: 'shipping_charges/shipping_charges' do
      @shipping_charges = ShippingCharge.find_by_address(params[:province], params[:city], params[:district])
    end
  end
end
