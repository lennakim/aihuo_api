class Setting < ActiveRecord::Base
  # extends ...................................................................
  # includes ..................................................................
  # relationships .............................................................
  # validations ...............................................................
  # callbacks .................................................................
  # scopes ....................................................................
  scope :transport_settings, -> { where(name: TRANSPORT_SETTING) }
  scope :weixin_fans, -> { where(name: WEIXIN_FANS) }
  # additional config (i.e. accepts_nested_attribute_for etc...) ..............
  TRANSPORT_SETTING = [
    :online_shipping_fee, :online_free_shipping_conditione, :online_description,
    :cash_shipping_fee, :cash_free_shipping_conditione, :cash_description
  ]
  WEIXIN_FANS = [:cart_weixin_visible, :cart_use_policy, :cart_weixin_id, :cart_weixin_content]
  # class methods .............................................................
  def self.invitation_sender
    self.fetch_by_key("private_message_send_for_register_member_robot_id")
  end

  def self.invitation_content
    self.fetch_by_key("private_message_send_for_register_member")
  end

  def self.fetch_by_key(key)
    Rails.cache.fetch(key, expires_in: 1.hours) do
      Setting.find_by_name(key).try(:value)
    end
  end
  # public instance methods ...................................................
  def self.get_paytype_shipping_conditione paytype
    case paytype
    when 0
      (Setting.find_by_name("online_free_shipping_conditione").try(:value) || 158).to_f.round(2)
    when 1
      (Setting.find_by_name("cash_free_shipping_conditione").try(:value) || 199).to_f.round(2)
    else
      nil
    end
  end

  def self.meet_condition?(pay_type, item_total)
    item_total >= Setting.get_paytype_shipping_conditione(pay_type)
  end
  # protected instance methods ................................................
  # private instance methods ..................................................
end
