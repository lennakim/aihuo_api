class Tactic < ActiveRecord::Base
  # extends ...................................................................
  # includes ..................................................................
  # relationships .............................................................
  belongs_to :setting, foreign_key: 'adv_setting_id'
  # validations ...............................................................
  # callbacks .................................................................
  # scopes ....................................................................
  # additional config (i.e. accepts_nested_attribute_for etc...) ..............
  self.table_name = "adv_tactics"
  serialize :adv_content_ids
  # class methods .............................................................
  # public instance methods ...................................................
  def adv_content_ids
    if self[:adv_content_ids]
      format_id = Proc.new { |id| id.to_i if id }
      self[:adv_content_ids].collect(&format_id).select { |id| id != 0 && id != nil }
    end
  end
  # protected instance methods ................................................
  # private instance methods ..................................................
end
