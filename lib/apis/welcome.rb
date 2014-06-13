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
        @submenus = page_for_360.contents
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


    # cache(key: [:v2, :home, @banners.last], expires_in: 2.days) do
    #   @banners
    #   @tags
    # end
  end

  get :notifications, jbuilder: 'welcome/notification' do
    @notifications = [
      {id: 1, title: '免费交友神器', description: "优质单身男女全部真实照片验证", image: 'http://image.yepcolor.com/images/20140606/ic_launcher.png', banner: 'http://blsm-public.oss.aliyuncs.com/images/20140610/adsense01.jpg', url: "http://image.yepcolor.com/downloads/ssf_v270_lsfc.apk", apk_sign: "cn.shuangshuangfei"},
      {id: 2, title: 'HOT男人', description: "最养眼美女一键保存", image: 'http://blsm-public.oss.aliyuncs.com/images/20140610/ic_launcher02.png', banner: 'http://blsm-public.oss.aliyuncs.com/images/20140610/adsense02.jpg', url: "http://blsm-public.oss.aliyuncs.com/downloads/110130565_v2.6.1.apk", apk_sign: "com.yoka.hotman"}
    ]
  end

end
