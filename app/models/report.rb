class Report < ActiveRecord::Base
  # extends ...................................................................
  # includes ..................................................................
  # relationships .............................................................
  # belongs_to :reportable, polymorphic: true
  # validations ...............................................................
  # TODO: 每个设备只能对同一个对象举报一次
  # callbacks .................................................................
  after_create :report_device_and_member
  skip_callback :create, :after, :report_device_and_member,
    if: -> { ["Member", "Device"].include? self.reportable_type }
  # scopes ....................................................................
  # additional config (i.e. accepts_nested_attribute_for etc...) ..............
  # class methods .............................................................
  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................
  private

  def report_device_and_member
    obj = self.reportable_type.constantize.find_by(id: self.reportable_id)
    report_object(obj.device_id, "Device")
    report_object(obj.member_id, "Member")
  end

  def report_object(reportable_id, reportable_type)
    if reportable_id
      report = Report.new(
        reportable_id: reportable_id,
        reportable_type: reportable_type,
        device_id: device_id,
        reason: reason
      )
      report.save
    end
  end
end
