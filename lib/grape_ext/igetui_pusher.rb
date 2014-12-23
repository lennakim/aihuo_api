module IGeTui
  class Pusher
    private

    def connect
      time_stamp = Time.now.to_i
      sign = Digest::MD5.hexdigest(app_key + time_stamp.to_s + master_secret)
      data = {
        action: 'connect',
        appkey: app_key,
        timeStamp: time_stamp,
        sign: sign
      }
      ret = http_post(data)

      base_str = "=" * 20
      base_str = "app_key: #{app_key} master_secret: #{master_secret}"
      MESSAGE_PUSHER_LOGGER.info base_str

      ret['result'] == 'success'
    end

    def http_post_json(params)
      params['version'] = '3.0.0.0'

      base_str = "=" * 20
      base_str = "params: #{params}"
      MESSAGE_PUSHER_LOGGER.info base_str
      ret = http_post(params)

      if ret && ret['result'] == 'sign_error'
        connect
        ret = http_post(params)
      end
      ret
    end
  end
end
