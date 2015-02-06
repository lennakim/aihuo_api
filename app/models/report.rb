class Report < ActiveRecord::Base
  # extends ...................................................................
  # includes ..................................................................
  # relationships .............................................................
  belongs_to :reportable, polymorphic: true
  # validations ...............................................................
  # TODO: 每个设备只能对同一个对象举报一次
  # callbacks .................................................................
  after_create :report_device_and_member, :delete_topic_or_reply
  # after_create :delete_topic_or_reply
  skip_callback :create, :after, :report_device_and_member, :delete_topic_or_reply,
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

  def delete_topic_or_reply
    model_id, model_type = self.reportable_id, self.reportable_type
    report_count = Report.where(reportable_type: model_type, reportable_id: model_id).count
    report_limit = Setting.find_by_name("#{model_type}_report_up_limit").value.to_i
    self.reportable.try(:destroy) if report_count >= report_limit
  end

end
