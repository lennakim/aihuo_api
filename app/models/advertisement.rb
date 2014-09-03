class Advertisement < ActiveRecord::Base
  # extends ...................................................................
  # includes ..................................................................
  include CarrierWave
  # relationships .............................................................
  has_many :adv_statistics, foreign_key: "adv_content_id"
  # validations ...............................................................
  # callbacks .................................................................
  # scopes ....................................................................
  # default_scope {
  #   where(activity: true).where("today_view_count < actual_view_count")
  #     .order("updated_at DESC")
  # }
  scope :available, ->(app) {
    scoped = where(activity: true)
    ids = app.advertisements.excessive_ids
    scoped.where("id NOT IN (?)", ids) unless ids.size.zero?
    scoped
  }
  scope :excessive, -> {
      joins(:adv_statistics).merge(AdvStatistic.today)
      .where(activity: true)
      .where("adv_statistics.install_count >= adv_contents.plan_view_count")
      .order("adv_contents.updated_at DESC")
      .distinct
  }

  scope :available, -> {
    Advertisement.select("adv_contents.*, sum(adv_statistics.install_count)")
    .joins(:adv_statistics).merge(AdvStatistic.today)
    .group("adv_contents.id")
    .having("sum(adv_statistics.install_count) < adv_contents.plan_view_count")
  }
  # additional config (i.e. accepts_nested_attribute_for etc...) ..............
  self.table_name = "adv_contents"
  # class methods .............................................................
  def self.increase_view_count
    all.map(&:increase_view_count)
  end

  def self.excessive_ids
    excessive.pluck(:id)
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
