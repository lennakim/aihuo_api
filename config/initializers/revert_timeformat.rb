# http://stackoverflow.com/questions/17805069/rails-activesupporttimewithzone-as-json-date-format-issue
# https://github.com/rails/rails/blob/master/activesupport/lib/active_support/time_with_zone.rb#L157
class ActiveSupport::TimeWithZone
# Changing the as_json method to remove the milliseconds from TimeWithZone to_json result (just like in Rails 3)
  def as_json(options = {})
    if ActiveSupport::JSON::Encoding.use_standard_json_time_format
      xmlschema
    else
      %(#{time.strftime("%Y/%m/%d %H:%M:%S")} #{formatted_offset(false)})
    end
  end
end
