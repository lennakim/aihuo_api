module HarmoniousFormatter
  extend ActiveSupport::Concern

  def body
    if self.attributes.include?("body")
      content = self[:body].strip.downcase
      ban_words = (Setting.find_by_name("ban_words").value || "").split("\n")
      ban_words.each { |word| content.gsub!(word.strip.downcase, "**") }
      content
    else
      raise NoMethodError.new("undefined method `body' for #{self}")
    end
  end

  def nickname
    if self.attributes.include?("nickname")
      content = self[:nickname]
      content.gsub!(/\d+/, '*')
      content
    else
      raise NoMethodError.new("undefined method `nickname' for #{self}")
    end
  end
end
