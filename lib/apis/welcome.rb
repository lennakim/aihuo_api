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
  end

  params do
    optional :register_date, type: String, desc: "Date looks like '20130401'."
    optional :filter, type: Symbol, values: [:healthy, :all], default: :all, desc: "Filtering for blacklist."
    optional :ref, type: String, desc: ""
  end
  get :home, jbuilder: 'welcome/home' do
    current_application
    cacke_key = [:v2, :home, params[:register_date], params[:filter], params[:ref]]
    cache(key: cacke_key, expires_in: 2.hours) do
      page_for_360 = Homepage.find_by(label: "首趣啪啪360")
      page_for_authority = Homepage.find_by(label: "首趣啪啪官方")
      page_for_skin = Homepage.find_by(label: "首趣啪啪皮肤")

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
        # @tags = Tag.where(id: Tag::CATEGORIES)
        if params[:ref] && params[:ref] == "360"
          # @submenus = page_for_360.contents.submenus
          @submenus = page_for_authority.contents.submenus
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
    @notifications = [
      {id: 1, title: '免费交友神器', description: "优质单身男女全部真实照片验证", image: 'http://image.yepcolor.com/images/20140606/ic_launcher.png', banner: 'http://blsm-public.oss.aliyuncs.com/images/20140610/adsense01.jpg', url: "http://image.yepcolor.com/downloads/ssf_v270_lsfc.apk", apk_sign: "cn.shuangshuangfei"},
      {id: 2, title: 'HOT男人', description: "最养眼美女一键保存", image: 'http://blsm-public.oss.aliyuncs.com/images/20140610/ic_launcher02.png', banner: 'http://blsm-public.oss.aliyuncs.com/images/20140610/adsense02.jpg', url: "http://blsm-public.oss.aliyuncs.com/downloads/110130565_v2.6.1.apk", apk_sign: "com.yoka.hotman"},
      # {id: 3, title: '百思不得姐', description: "各种精彩的内涵段子、糗事、秘密话题，应有尽有", image: 'http://blsm-public.oss.aliyuncs.com/images/20140613/adsense03.png', banner: 'http://blsm-public.oss.aliyuncs.com/images/20140613/adsense03big.jpg', url: "http://blsm-public.oss.aliyuncs.com/downloads/budejie_3.8.3-sq.apk", apk_sign: "com.budejie.www"}
    ]
  end

  params do
    optional :channel, type: String, desc: "Date looks like '20130401'."
  end
  get :adsenses, jbuilder: 'welcome/adsenses' do
    current_application
    @adsenses = [
      {id: 1, title: '免费交友神器', banner: 'http://blsm-public.oss.aliyuncs.com/images/20140610/adsense01.jpg', url: "http://image.yepcolor.com/downloads/ssf_v270_lsfc.apk", apk_sign: "cn.shuangshuangfei"},
      {id: 2, title: 'HOT男人', banner: 'http://blsm-public.oss.aliyuncs.com/images/20140610/adsense02.jpg', url: "http://blsm-public.oss.aliyuncs.com/downloads/110130565_v2.6.1.apk", apk_sign: "com.yoka.hotman"}
    ]
    @tactics = [
      {id: 1, type: 3, value: "from_commu_to_topicdetail"},
      {id: 2, type: 2, value: "23:00"},
      {id: 3, type: 1, value: "20"},
    ]
  end

end
