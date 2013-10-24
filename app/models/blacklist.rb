class Blacklist < ActiveRecord::Base
  # extends ...................................................................
  # includes ..................................................................
  # security (i.e. attr_accessible) ...........................................
  # relationships .............................................................
  # validations ...............................................................
  validates_uniqueness_of :device_id, :scope => :node_id
  # callbacks .................................................................
  # scopes ....................................................................
  # additional config .........................................................
  self.table_name = "block_lists"
  # class methods .............................................................
  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................
end
