class Advertisement < ActiveRecord::Base
  # extends ...................................................................
  # includes ..................................................................
  include CarrierWave
  # relationships .............................................................
  # validations ...............................................................
  # callbacks .................................................................
  # scopes ....................................................................
  default_scope {
    where(activity: true).where("today_view_count < actual_view_count")
      .order("updated_at DESC")
  }
  # additional config (i.e. accepts_nested_attribute_for etc...) ..............
  self.table_name = "adv_contents"
  # class methods .............................................................
  def self.increase_view_count
    all.map(&:increase_view_count)
  end

  def increase_view_count
    update_columns({
      today_view_count: today_view_count + 1,
      total_view_count: total_view_count + 1
    })
  end

  def baidu_pan_url
    if id == 4
      "https://pcs.baidu.com/rest/2.0/pcs/file?method=download&access_token=23.00f332af7bb1da1390a33e48ab5d4d60.2592000.1407039697.2667843560-2742236&path=%2Fapps%2Fsft_fresh%2F3999011_ip.apk"
    else
      carrierwave_material(nil, :url)
    end
  end
  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................
end
