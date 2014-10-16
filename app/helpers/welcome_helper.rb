module WelcomeHelper
  extend Grape::API::Helpers

  params :home do
    optional :register_date, type: String, desc: "Date looks like '20130401'."
    optional :filter, type: Symbol, values: [:healthy, :all], default: :all, desc: "Filtering for blacklist."
    optional :ref, type: String, desc: ""
  end

  params :channel do
    optional :channel, type: String, default: AdvertisementSetting::DEFAULT_CHANNL, desc: "channel name."
  end

  params :ver do
    optional :ver, type: String, desc: "version number."
  end

  def date_param
    date = request.headers["Registerdate"] || params[:register_date]
    date.to_date if date
  end

  # 未传递用户注册日期，或用户注册日期不在三天内，不显示0元购宝典
  def hide_gift_products?
    date_param.blank? || date_param < 2.days.ago(Date.today)
  end

  def hours_now
    Time.now.strftime("%H").to_i
  end

  def profile_number
    if 14 < hours_now && hours_now < 20
      "1"
    elsif 20 <= hours_now || hours_now <= 2
      "2"
    else
      "0"
    end
  end

  def cacke_key
    [:v2, :home, params[:api_key], params[:register_date], params[:filter], params[:ref], profile_number]
  end

  def get_homepage_data
    homepages = Homepage.for_app(@application).by_hour(profile_number)
    page_for_360 = homepages.find_by(label: "360")
    page_for_authority = homepages.find_by(label: "官方")
    page_for_skin = homepages.find_by(label: "皮肤")
    [page_for_360, page_for_authority, page_for_skin]
  end

  def get_banners(filter)
    case filter
    when :healthy
      @banners = Article.healthy.limit(2)
    when :all
    @banners =
      if hide_gift_products?
        @application.articles.banner.without_gifts
      else
        @application.articles.banner
      end
    end
  end

  def get_sections(page)
    proc = Proc.new { |sections, item| sections << page.contents.sections(item) }
    @sections = HomeContent::SECTIONS.inject([], &proc)
    @sections.reject! { |s| s.count.zero? }
  end

  def get_submenus(page)
    @submenus = page ? page.contents.submenus : []
  end

  def get_brands(page)
    @brands = page ? page.contents.brands : []
  end

  def get_categories(page)
    @categories = page ? page.contents.categories : []
  end
end
