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

    case params[:filter]
    when :healthy
      @banners = Article.healthy.limit(2)
      @submenus = [
        {id: "", type: 'Tag', title: '最新产品', name: "最新产品", image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/majia/1/1-01.png'},
        {id: "", type: 'Tag', title: '趣友推荐', name: "趣友推荐", image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/majia/1/1-02.png'},
        {id: "", type: 'Tag', title: '火爆套套', name: "火爆套套", image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/majia/1/1-03.png'}
      ]
      @categories = []
      @sections = [
        {
          name: "热销区",
          objects: [
            {id: "", type: 'Tag', title: '火爆热销', image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/majia/2/huodingyi-1.png'},
            {id: "eac09ca04140a8a4edbe5f0f62488c46", type: 'Product', title: '阻复环', image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/majia/2/2-01.png'},
            {id: "8b40966990e68df56d07c0d0047b7e3f", type: 'Product', title: '震动跳蛋', image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/majia/2/2-02.png'},
            {id: "5a35dc7f93a32a255aec912682d9d810", type: 'Product', title: '调情香氛', image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/majia/2/2-03.png'},
            {id: "ec46e4d35f6ccdf7994777f85cb928d6", type: 'Product', title: '本草堂', image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/majia/2/2-04.png'},
            {id: "2ade7cbb1f300ada6eb197b23f79eb49", type: 'Product', title: '延时喷剂', image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/majia/2/2-05.png'}
          ]
        },
        {
          name: "新品区",
          objects: [
            {id: "41aa3fac21a9f0c681878d8c337c3d1b", type: 'Article', title: '', image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/majia/2/huodong-2.png'},
            {id: "25ac52b0efdafca460d8f5aa7231f1a5", type: 'Product', title: '精油润滑液', image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/majia/2/2-06.png'},
            {id: "7e831a6f3afc17101e5bfc4baf86a92f", type: 'Product', title: '延时湿巾', image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/majia/2/2-07.png'},
            {id: "1a338177155b847cf46bd6dd884f38cf", type: 'Product', title: '舔食润滑液', image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/majia/2/2-08.png'},
            {id: "4919fd3797a1501de84cce0a0eda3c9c", type: 'Product', title: '幻彩跳蛋', image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/majia/2/2-09.png'},
            {id: "66d9165b20475b299359b6a73de1c384", type: 'Product', title: '男性延时', image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/majia/2/2-10.png'}
          ]
        },
        {
          name: "主题馆",
          objects: [
            {id: "", type: 'Tag', title: '日常战备', image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/majia/2/huodong-3.jpg'},
            {id: "afd3988ca620a9c5d2e8cf90b8b40b16", type: 'Product', title: '糖果安全套', image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/majia/2/2-11.png'},
            {id: "030e288ce9f3cab3858a479ec7c0355d", type: 'Product', title: '加倍润滑', image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/majia/2/2-12.png'},
            {id: "3931f4abe7c946249eba777e981f2f1e", type: 'Product', title: '薄如羽翼', image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/majia/2/2-13.png'},
            {id: "cff809c998e8b2f83482105da60877ff", type: 'Product', title: '活力螺纹', image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/majia/2/2-14.png'},
            {id: "37c809b674331025f4e7186cd4f8a298", type: 'Product', title: '延时持久', image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/majia/2/2-15.png'}
          ]
        }
      ]
      @brands = []
    when :all
      # @banners =
      #   if hide_gift_products?
      #     # FIXME:
      #     # @application.articles.banner_without_gifts not works, don't know why
      #     # Article.banner_without_gifts.where(application_id: @application.id)
      #     Article.banner_without_gifts
      #   else
      #     @application.articles.banner
      #   end
      @banners = @application.articles.banner
      # @tags = Tag.where(id: Tag::CATEGORIES)
      if params[:ref] && params[:ref] == "360"
        @submenus = [
          {id: "", type: 'Tag', title: '最新产品', name: "新品特价", image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/home/1/1-01.png'},
          {id: "3f9d7b0f3e42047bae820ab941d75a23", type: 'Article', title: '360特权专享',image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/home/1/1-04.png'},
          {id: "", type: 'Tag', title: '火爆套套', name: "火爆套套", image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/home/1/1-03.png'}
        ]
      else
        @submenus = [
          {id: "", type: 'Tag', title: '最新产品', name: "新品特价", image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/home/1/1-01.png'},
          {id: "", type: 'Tag', title: '100件抢完算', name: "100件抢完算", image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/home/1/1-02.png'},
          {id: "", type: 'Tag', title: '火爆套套', name: "火爆套套", image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/home/1/1-03.png'}
        ]
      end
      @categories = [
        {id: "", type: 'Tag', title: '男士专区', name: "男用", image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/home/3/fenlei-01.png'},
        {id: "", type: 'Tag', title: '女士专区', name: "女用", image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/home/3/fenlei-02.png'},
        {id: "", type: 'Tag', title: '性感服饰', name: "更多情趣", image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/home/3/fenlei-03.png'},
        {id: "", type: 'Tag', title: '助情助兴', name: "最近有点烦", image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/home/3/fenlei-04.png'},
        {id: "", type: 'Tag', title: '夫妻情侣', name: "高潮迭起", image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/home/3/fenlei-05.png'},
        {id: "", type: 'Tag', title: '套套润滑', name: "日常战备", image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/home/3/fenlei-06.png'}
      ]
      @sections = [
        {
          name: "热销区",
          objects: [
            {id: "", type: 'Tag', title: '热销专区', image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/home/2/huodong-1.png'},
            {id: "25c79602f6b190489ea54efbc66e6846", type: 'Product', title: '蕾丝诱惑', image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/home/2/2-01.png'},
            {id: "4919fd3797a1501de84cce0a0eda3c9c", type: 'Product', title: '幻彩跳蛋', image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/home/2/2-02.png'},
            {id: "5a35dc7f93a32a255aec912682d9d810", type: 'Product', title: '调情香氛', image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/home/2/2-03.png'},
            {id: "7e831a6f3afc17101e5bfc4baf86a92f", type: 'Product', title: '延时湿巾', image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/home/2/2-04.png'},
            {id: "ec46e4d35f6ccdf7994777f85cb928d6", type: 'Product', title: '延时喷剂', image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/home/2/2-05.png'}
          ]
        },
        {
          name: "五月大促",
          objects: [
            {id: "6bf3a8fb35a00dc171dbe679f07e09d5", type: 'Article', title: '', image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/home/2/huodong-2.png'},
            {id: "eac09ca04140a8a4edbe5f0f62488c46", type: 'Product', title: '阻复环', image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/home/2/2-06.png'},
            {id: "4e0d1282868113aed2ebfe4341a61d85", type: 'Product', title: '免提飞机杯', image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/home/2/2-07.png'},
            {id: "25ac52b0efdafca460d8f5aa7231f1a5", type: 'Product', title: '精油润滑液', image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/home/2/2-08.png'},
            {id: "940e3a4f2b406a1c93e1f0425d5d52da", type: 'Product', title: '开裆丁字裤', image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/home/2/2-09.png'},
            {id: "881ddca05b03e73877b5d327ab04e5a1", type: 'Product', title: '震动飞机杯', image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/home/2/2-10.png'}
          ]
        },
        {
          name: "新婚初夜装",
          objects: [
            {id: "", type: 'Tag', title: '新婚初夜装', image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/home/2/huodong-3.png'},
            {id: "e71107667db60e03889ecab3c137bfcf", type: 'Product', title: '学生服', image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/home/2/2-11.png'},
            {id: "f4c00fc8db0da67cf0e1f93ac4c81462", type: 'Product', title: '性感精灵', image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/home/2/2-12.png'},
            {id: "9ea1d60328ae4a08627fe3de9a38514e", type: 'Product', title: '性感蕾丝', image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/home/2/2-13.png'},
            {id: "f5e933eb6af093b9aa6ece2281406a69", type: 'Product', title: 'SM女王装', image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/home/2/2-14.png'},
            {id: "7163f18ab7de9a11d20085e20ee338fc", type: 'Product', title: '蕾丝网纱', image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/home/2/2-15.png'}
          ]
        }
      ]
      @brands = [
        {id: nil, type: 'Tag', title: '杜蕾斯', image: "http://blsm-public.oss.aliyuncs.com/images/20140509/home/4/pingpai-01.png"},
        {id: nil, type: 'Tag', title: '诺兰', image: "http://blsm-public.oss.aliyuncs.com/images/20140509/home/4/pingpai-02.png"},
        {id: nil, type: 'Tag', title: '名流', image: "http://blsm-public.oss.aliyuncs.com/images/20140509/home/4/pingpai-03.png"},
        {id: nil, type: 'Tag', title: '尚牌', image: "http://blsm-public.oss.aliyuncs.com/images/20140509/home/4/pingpai-04.png"}
      ]
    end


    # cache(key: [:v2, :home, @banners.last], expires_in: 2.days) do
    #   @banners
    #   @tags
    # end
  end

end
