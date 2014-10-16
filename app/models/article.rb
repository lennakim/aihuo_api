class Article < ActiveRecord::Base
  # extends ...................................................................
  acts_as_paranoid
  acts_as_taggable_on :tags
  # includes ..................................................................
  include EncryptedId
  include CarrierWaveMini
  include ArticleFormatter
  # relationships .............................................................
  has_many :resources, :as => :resable
  # validations ...............................................................
  # callbacks .................................................................
  # scopes ....................................................................
  default_scope { order("position DESC") }
  scope :gifts, -> { where(title: "0元任你购 你想要我就敢送！") }
  scope :banner, -> { where(:banner => true) }
  scope :available, -> {
    where(
      "activate_at IS NULL OR (activate_at <= ? AND expire_at >= ?)",
      Date.today,
      Date.today
    )
  }
  scope :search, ->(date, today) {
    # 未传递用户注册日期，或用户注册日期不在三天内，不显示0元购宝典
    if date.blank? || date && today && date < 2.days.ago(today)
      gifts_ids = Article.gifts.pluck(:id)
      where(:banner => false).where.not(id: gifts_ids)
    end
  }
  scope :without_gifts, -> {
    gifts_ids = Article.gifts.pluck(:id)
    where.not(id: gifts_ids)
  }
  scope :healthy, -> { tagged_with("配合扫黄", any: true) }
  # additional config (i.e. accepts_nested_attribute_for etc...) ..............
  encrypted_id key: 'AJ03lQmVmtomCfug'
  # class methods .............................................................
  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................
end
