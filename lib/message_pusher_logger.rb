class MessagePusherLogger < Logger
  def format_message(severity, timestamp, progname, msg)
    "#{msg}\n"
  end
end

logfile = File.open(Rails.root.join("log", "message_pusher.log"), 'a')  #create log file
logfile.sync = true  #automatically flushes data to file
MESSAGE_PUSHER_LOGGER = MessagePusherLogger.new(logfile)  #constant accessible anywhere
