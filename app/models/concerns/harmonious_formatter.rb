module HarmoniousFormatter
  extend ActiveSupport::Concern

  def body
    if self.attributes.include?("body")
      content = self[:body].strip.downcase
      ban_words = (Setting.find_by_name("ban_words").value || "").split("\n")
      # Notice: incompatible encoding regexp match (ASCII-8BIT regexp with UTF-8 string)
      # force_encoding("UTF-8") can be fixd this error.
      ban_words.each { |word| content.force_encoding("UTF-8").gsub!(word.strip.downcase, "**") }
      content
    else
      raise NoMethodError.new("undefined method `body' for #{self}")
    end
  end

  def nickname
    if self.attributes.include?("nickname")
      content = self[:nickname]
      str = "操、插、逼、尻、吸、舔、肏、日、草、鸡、屄、骚、阴唇、阴蒂、阴毛、鸡吧、鸡巴、兼职、诚聘、QQ、微信、代理、招商、商城、淘宝、天猫、成人用品、约炮、一夜情、文爱、图爱、裸聊、棒棒、肉棒、艹尼玛、jj、\\d+"
      reg_str = str.split("、").join("|")
      reg_str.insert(0, "(")
      reg_str.insert(-1, ")")
      reg = Regexp.new(reg_str)
      content.gsub!(reg, '*') if content
      content
    else
      raise NoMethodError.new("undefined method `nickname' for #{self}")
    end
  end
end
