class Device < ActiveRecord::Base
  # extends ...................................................................
  # includes ..................................................................
  include EncryptedId
  # relationships .............................................................
  has_one :device_info, :primary_key => "device_id"
  # validations ...............................................................
  validates :device_id, presence: true, uniqueness: true
  # callbacks .................................................................
  # scopes ....................................................................
  # additional config (i.e. accepts_nested_attribute_for etc...) ..............
  encrypted_id key: 'zhKJmvPjguc33pvQ'
  # class methods .............................................................
  DEVICE_SAFE_UP_LIMIE = "10"

  def self.is_in_safe_condition?(device_id)
    safe_up_limit = Setting.fetch_by_key("device_safe_up_limit", Device::DEVICE_SAFE_UP_LIMIE)
    update_time = Report.where(device_id: device_id, reportable_type: self.name).last.try(:updated_at) || Time.now
    cache_key = [device_id, "report", update_time.to_date.to_s].join("_")
    # report_count = Rails.cache.fetch(cache_key, expires_in: 1.hours) do
    report_count = Report.where(reportable_id: device_id, reportable_type: self.name, created_at: Date.today.beginning_of_day..Date.today.end_of_day).count
    # end
    report_count < safe_up_limit.to_i
  end

  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................
end
