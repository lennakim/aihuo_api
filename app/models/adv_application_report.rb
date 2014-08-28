class AdvApplicationReport < ActiveRecord::Base
  # extends ...................................................................
  # includes ..................................................................
  # relationships .............................................................
  belongs_to :application
  # validations ...............................................................
  # callbacks .................................................................
  # scopes ....................................................................
  default_scope { order("created_at DESC") }
  scope :by_app, ->(app_id) { where(application_id: app_id) }
  scope :today, -> {
    where(created_at: Date.today.midnight..Date.today.end_of_day)
  }
  # additional config (i.e. accepts_nested_attribute_for etc...) ..............
  # class methods .............................................................
  def self.alert(app_id)
    report = today.by_app(app_id).first_or_create
    report.increase_count
  end
  # public instance methods ...................................................
  def increase_count
    update_attribute(:warning_count, warning_count + 1)
  end
  # protected instance methods ................................................
  # private instance methods ..................................................
end