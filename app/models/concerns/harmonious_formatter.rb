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
      content.gsub!(/\d+/, '*') if content
      content
    else
      raise NoMethodError.new("undefined method `nickname' for #{self}")
    end
  end
end
