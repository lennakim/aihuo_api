module HarmoniousFormatter
  extend ActiveSupport::Concern

  included do
    def body
      content = self[:body].strip.downcase
      ban_words = (Setting.find_by_name("ban_words").value || "").split("\n")
      ban_words.each { |word| content.gsub!(word.strip.downcase, "**") }
      content
    end
  end
end
