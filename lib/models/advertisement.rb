class Advertisement < ActiveRecord::Base
  # extends ...................................................................
  # includes ..................................................................
  # relationships .............................................................
  # validations ...............................................................
  # callbacks .................................................................
  # scopes ....................................................................
  default_scope { where(active: true).order("id DESC") }
  # additional config (i.e. accepts_nested_attribute_for etc...) ..............
  self.table_name = "adv_contents"
  # class methods .............................................................
  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................
end
