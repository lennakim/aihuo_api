module ShippingChargeMethod
  class << self
    def default_shipping_charge; [15, 15]; end
    alias_method :shipping_charge, :default_shipping_charge
  end

  private
  def get_shippint_charge(obj = nil)
    if cash_on_delivery == 0 || pay_online == 0
      obj.nil? ? ShippingChargeMethod.default_shipping_charge : obj.shipping_charge
    else
      [cash_on_delivery, pay_online]
    end
  end
end

class Province < ActiveRecord::Base
  has_many :cities, dependent: :destroy
  include ShippingChargeMethod
  def shipping_charge; get_shippint_charge; end
end

class City < ActiveRecord::Base
  belongs_to :province
  has_many :districts, dependent: :destroy
  include ShippingChargeMethod
  def shipping_charge; get_shippint_charge(province); end
end

class District < ActiveRecord::Base
  belongs_to :city
  include ShippingChargeMethod
  def shipping_charge; get_shippint_charge(city); end
end

class ShippingCharge
  include ShippingChargeMethod
  attr_accessor :express, :cash_on_delivery, :pay_online

  def initialize(cash_on_delivery, pay_online, express = '圆通')
    @express = express
    @cash_on_delivery = cash_on_delivery
    @pay_online = pay_online
  end

  def self.find_by_address(province_name, city_name, district_name)
    province = Province.find_by_name(province_name)
    city = province.cities.find_by_name(city_name) if province
    district = city.districts.find_by_name(district_name) if city

    cash_on_delivery, pay_online =
      [district, city, province, ShippingCharge].select { |obj| !obj.nil? }
        .first.shipping_charge
    Array.new(1, ShippingCharge.new(cash_on_delivery, pay_online))
  end
end
