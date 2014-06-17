# Fixing ActiveRecord concurrency issues in a rack application (without Rails)
# http://www.lucasallan.com/2014/05/26/fixing-concurrency-issues-with-active-record-in-a-rack-application.html
module ActiveRecord
  class Base
    singleton_class.send(:alias_method, :original_connection, :connection)

    def self.connection
      ActiveRecord::Base.connection_pool.with_connection do |conn|
        conn
      end
    end
  end
end
