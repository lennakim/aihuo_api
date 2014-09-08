class Advertisement < ActiveRecord::Base
  # extends ...................................................................
  # includes ..................................................................
  include CarrierWave
  # relationships .............................................................
  has_many :adv_statistics, foreign_key: "adv_content_id"
  # validations ...............................................................
  # callbacks .................................................................
  # scopes ....................................................................
  scope :available, -> { where(adv_contents: { activity: true }) }
  scope :unavailable, -> {
    select("adv_contents.*, SUM(adv_statistics.install_count) AS ic")
      .where(adv_contents: { activity: true })
      .joins(:adv_statistics).merge(AdvStatistic.today)
      .group("adv_contents.id")
      .having("ic >= adv_contents.plan_view_count")
  }
  # additional config (i.e. accepts_nested_attribute_for etc...) ..............
  self.table_name = "adv_contents"
  # class methods .............................................................
  def self.available_ids
    available.pluck(:id)
  end

  def self.unavailable_ids
    unavailable.all.map { |advertisement| advertisement.id }
  end

  def self.by_tactics(tactics)
    combination = Proc.new { |ids, obj| ids << obj.adv_content_ids.to_a }
    ids = tactics.inject([], &combination).flatten!
    ids.blank? ? none : where(id: (ids & available_ids) - unavailable_ids)
  end

  def self.increase_view_count
    all.map(&:increase_view_count)
  end

  # public instance methods ...................................................
  def increase_view_count
    update_columns({
      today_view_count: today_view_count + 1,
      total_view_count: total_view_count + 1
    })
  end
  # protected instance methods ................................................
  # private instance methods ..................................................
end
