class Report < ActiveRecord::Base
  # extends ...................................................................
  # includes ..................................................................
  # relationships .............................................................
  belongs_to :reportable, polymorphic: true
  validates_uniqueness_of :reportable_id, scope: [:device_id, :reportable_type], if: ->(reply) {["Reply", "Topic"].include?(reply.reportable_type)}
  # validations ...............................................................
  # TODO: 每个设备只能对同一个对象举报一次
  # callbacks .................................................................
  after_create :report_device_and_member
  # after_create :delete_topic_or_reply
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
    if obj
      report_object(obj.device_id, "Device")
      report_object(obj.member_id, "Member")
      obj.update_report_num
      report_times = Report.member_report_num(obj.member_id)
      Member.find_by(id: obj.member_id).update_member_report_num_filter(report_times)
    end
  end

  def report_object(reportable_obj_id, reportable_obj_type)
    if reportable_obj_id && reportable_obj_type
      Report.create(
        reportable_id: reportable_obj_id,
        reportable_type: reportable_obj_type,
        device_id: device_id,
        reason: reason
      )
    end
  end

  def self.member_report_num(i_member_id)
    Report.where(reportable_id: i_member_id, reportable_type: "Member", created_at: Date.today.beginning_of_day..Date.today.end_of_day).count
  end
end
