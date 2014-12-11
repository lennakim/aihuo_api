class Advertisement < ActiveRecord::Base
  # extends ...................................................................
  # includes ..................................................................
  include CarrierWaveMini
  include MemcachedHelper

  default_scope {where(trash: false, deleted: false)}
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
    advertisement_ids = collection_advertisement_ids(tactics, control_volume)
    ids.blank? ? none : where(id: advertisement_ids)
  end

  def self.increase_view_count
    all.map(&:increase_view_count_to_cache)
  end

  def self.collection_advertisement_ids(tactics, control_volume)
    ids = collection_advertisement_ids_by_tactics(tactics, control_volume)
    advertisement_ids = ids & available_ids
    control_volume ? advertisement_ids - unavailable_ids : advertisement_ids
  end

  def self.collection_advertisement_ids_by_tactics(tactics, control_volume)
    combination = Proc.new { |ids, obj| ids << obj.adv_content_ids.to_a }
    ids = tactics.inject([], &combination).flatten! || [] # 如果策略为空，表示这个APP没有配置广告，设置一个空数组
    ids = available_ids if ids.empty? && !control_volume # 如果策略为空，且不控量。广告墙需要需要这样的策略
    ids
  end

  # public instance methods ...................................................
  def increase_view_count_to_cache
    incr_value_in_memcached('advertisement_ids', id.to_s)
  end

  def increase_view_count_from_cache(count)
    update_columns({
      today_view_count: today_view_count + count,
      total_view_count: total_view_count + count
    })
  end

  # protected instance methods ................................................
  # private instance methods ..................................................
end
