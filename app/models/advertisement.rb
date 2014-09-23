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

  def self.by_tactics(tactics, control_volume: true)
    combination = Proc.new { |ids, obj| ids << obj.adv_content_ids.to_a }
    ids = tactics.inject([], &combination).flatten!
    ids = available_ids if ids.nil? && !control_volume # 如果策略为空，且不控量。广告墙需要需要这样的策略
    advertisement_ids = ids & available_ids
    advertisement_ids = control_volume ? advertisement_ids - unavailable_ids : advertisement_ids
    ids.blank? ? none : where(id: advertisement_ids)
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
