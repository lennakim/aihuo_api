class Member < ActiveRecord::Base
  # extends ...................................................................
  encrypted_id key: 'uwGeTjFYo9z9NpoN'
  # includes ..................................................................
  # mount_uploader :avatar, AvatarUploader
  # relationships .............................................................
  has_many :devices
  # validations ...............................................................
  validates :nickname, presence: true, uniqueness: true, length: 2..16
  # callbacks .................................................................
  # scopes ....................................................................
  # additional config (i.e. accepts_nested_attribute_for etc...) ..............
  attr_reader :password
  # class methods .............................................................
  def self.encrypt_password(password, salt)
    Digest::SHA2.hexdigest(password + "yepcolor" + salt)
  end
  # public instance methods ...................................................
  def authenticate?(password)
    hashed_password == encrypt_password(password, salt)
  end

  def password=(password)
    @password = password

    if password.present?
      generate_salt
      self.hashed_password = self.class.encrypt_password(password, salt)
    end
  end

  def can_send_captcha?
    # 对于验证过手机号的用户，暂时不再允许验证
    return false if verified
    # 第一次创建的用户，发送验证码时间是空
    return true if captcha_updated_at.blank?
    # 上次发送时间在2分钟之前，并且当天发送次数在3次以内
    captcha_updated_at < Time.now.ago(120) && captcha_flag <= 4
  end

  def send_captcha
    return if !can_send_captcha?
    generate_captcha

    ChinaSMS.use(
      :emay,
      username: Setting.find_by_name(:sms_key).value,
      password: Setting.find_by_name(:sms_pwd).value
    )
    message = "手机验证码:#{captcha}【首趣商城】"
    # ChinaSMS.to phone, message
  end

  def validate_captcha?(phone, captcha)
    self.phone == phone && self.captcha == captcha && !verified
  end

  def verified!
    update_column(:verified, true)
  end

  def relate_to_device(device_id)
    verified!
    device = Device.find_by(device_id: device_id)
    device.update_column(:member_id, self.id) if device
  end
  # protected instance methods ................................................
  # private instance methods ..................................................
  private

  def generate_captcha
    self.captcha = SecureRandom.random_number.to_s[2, 6]
    set_flag
  end

  def set_flag
    self.captcha_flag = should_reset_flag? ? 0 : captcha_flag + 1
    self.captcha_updated_at = Time.now
    self.password = captcha
    save
  end

  def should_reset_flag?
    return true if captcha_updated_at.blank?
    captcha_updated_at.to_date != Date.today
  end

  def generate_salt
    self.salt = SecureRandom.hex
  end
end
