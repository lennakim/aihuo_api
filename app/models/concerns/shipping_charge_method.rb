module ShippingChargeMethod
  extend ActiveSupport::Concern

  included do
  end

  module ClassMethods
    def default_shipping_charge; [12, 12]; end
    alias_method :shipping_charge, :default_shipping_charge
  end

  def shipping_charge
    get_shippint_charge(superior_region)
  end

  private

  def superior_region
    self
  end

  def get_shippint_charge(obj = nil)
    if cash_on_delivery == 0 || pay_online == 0
      obj.nil? ? ShippingChargeMethod.default_shipping_charge : obj.shipping_charge
    else
      [cash_on_delivery, pay_online]
    end
  end
end
