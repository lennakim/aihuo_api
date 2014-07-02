class Welcome < Grape::API
  helpers do
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
  end

  params do
    optional :register_date, type: String, desc: "Date looks like '20130401'."
    optional :filter, type: Symbol, values: [:healthy, :all], default: :all, desc: "Filtering for blacklist."
    optional :ref, type: String, desc: ""
  end
  get :home, jbuilder: 'welcome/home' do
    current_application

    cacke_key = [
      :v2,
      :home,
      params[:register_date],
      params[:filter],
      params[:ref],
      profile_number
    ]

    cache(key: cacke_key, expires_in: 5.minutes) do
      page_for_360 = Homepage.by_hour(profile_number).find_by(label: "首趣啪啪360")
      page_for_authority = Homepage.by_hour(profile_number).find_by(label: "首趣啪啪官方")
      page_for_skin = Homepage.by_hour(profile_number).find_by(label: "首趣啪啪皮肤")

      case params[:filter]
      when :healthy
        @banners = Article.healthy.limit(2)
        @submenus = page_for_skin.contents.submenus
        @categories = []
        @sections = [
          page_for_skin.contents.sections(1),
          page_for_skin.contents.sections(2),
          page_for_skin.contents.sections(3),
        ]
        @brands = []
      when :all
        @banners =
          if hide_gift_products?
            # FIXME:
            # @application.articles.banner_without_gifts not works, don't know why
            # Article.banner_without_gifts.where(application_id: @application.id)
            @application.articles.banner.without_gifts
          else
            @application.articles.banner
          end
        if params[:ref] && params[:ref] == "360"
          @submenus = page_for_360.contents.submenus
        else
          @submenus = page_for_authority.contents.submenus
        end
        @categories = page_for_authority.contents.categories
        @sections = [
          page_for_authority.contents.sections(1),
          page_for_authority.contents.sections(2),
          page_for_authority.contents.sections(3),
        ]
        @brands = page_for_authority.contents.brands
      end
    end
  end

  get :notifications, jbuilder: 'welcome/notification' do
    @notifications = Advertisement.all
  end

  params do
    optional :channel, type: String, desc: "channel name."
    optional :var, type: String, desc: "version number."
  end
  get :adsenses, jbuilder: 'welcome/adsenses' do
    current_application
    @advertisements =
      if params[:ver].present?
        @application.advertisements
      else
        @application.advertisements.reorder("id DESC").limit(1)
      end
    @advertisements.increase_view_count

    setting = AdvertisementSetting.by_channel_and_app(params[:channel], @application).first
    @tactics = setting ? setting.tactics : Tactic.all
  end

  get :latest_apk do
    @lasted_apk_url = Setting.find_by(name: 'latest_apk_url')
    @lasted_apk_url.to_json(only: [:value, :updated_at])
  end

end
