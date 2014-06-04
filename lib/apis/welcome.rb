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
        {id: "", type: 'Tag', title: '小编首推', name: "小编首推", image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/majia/1/1-02.png'},
        {id: "", type: 'Tag', title: '火爆套套', name: "火爆套套", image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/majia/1/1-03.png'}
      ]
      @categories = []
      @sections = [
        {
          name: "热销区",
          objects: [
            {id: "", type: 'Tag', title: '火爆热销', image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/majia/2/huodingyi-1.png'},
            {id: "b0fb128360d9eb2171819a741f7d0eda", type: 'Product', title: '360随身WIFI', image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/majia/2/2-01.png'},
            {id: "d83c8ea92c4790886bf52bc99bd225b1", type: 'Product', title: '冰希黎香水', image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/majia/2/2-02.png'},
            {id: "737b636c96a09d2d9afad194489f46ff", type: 'Product', title: '短袖睡衣', image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/majia/2/2-03.png'},
            {id: "1e999e791e9d22690834f36f1b8424c9", type: 'Product', title: '压床娃娃', image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/majia/2/2-04.png'},
            {id: "5a35dc7f93a32a255aec912682d9d810", type: 'Product', title: '调情香氛', image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/majia/2/2-05.png'}
          ]
        },
        {
          name: "新品区",
          objects: [
            {id: "41aa3fac21a9f0c681878d8c337c3d1b", type: 'Article', title: '', image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/majia/2/huodong-2.png'},
            {id: "97bf5112af787c1ede0ae5286aaeef59", type: 'Product', title: '头戴耳机', image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/majia/2/2-06.png'},
            {id: "2ae1e396ac0844323c08a0839c5e123a", type: 'Product', title: '丹姿水密码', image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/majia/2/2-07.png'},
            {id: "1a338177155b847cf46bd6dd884f38cf", type: 'Product', title: '舔食润滑液', image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/majia/2/2-08.png'},
            {id: "77fe08c4207a11fee2aa05cc6baa89c4", type: 'Product', title: '金鱼树脂', image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/majia/2/2-09.png'},
            {id: "38f213dc99a2e4aa1e03b78e498d412a", type: 'Product', title: '笔筒高档', image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/majia/2/2-10.png'}
          ]
        },
        {
          name: "主题馆",
          objects: [
            {id: "", type: 'Tag', title: '日常战备', image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/majia/2/huodong-3.jpg'},
            {id: "afd3988ca620a9c5d2e8cf90b8b40b16", type: 'Product', title: '糖果安全套', image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/majia/2/2-11.png'},
            {id: "cff809c998e8b2f83482105da60877ff", type: 'Product', title: '活力螺纹', image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/majia/2/2-12.png'},
            {id: "3931f4abe7c946249eba777e981f2f1e", type: 'Product', title: '薄如羽翼', image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/majia/2/2-13.png'},
            {id: "facc69582169e4d0359a60963b02d646", type: 'Product', title: '精品文胸', image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/majia/2/2-14.png'},
            {id: "5b3aed411b575776f855a1dc5aefb7fd", type: 'Product', title: '私处洗液', image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/majia/2/2-15.png'}
          ]
        }
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
        @submenus = [
          {id: "", type: 'Tag', title: '新品特价', name: "新品特价", image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/home/1/1-01.png'},
          {id: "3f9d7b0f3e42047bae820ab941d75a23", type: 'Article', title: '360特权专享',image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/home/1/1-04.png'},
          {id: "", type: 'Tag', title: '火爆套套', name: "火爆套套", image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/home/1/1-03.png'}
        ]
      else
        @submenus = [
          {id: "", type: 'Tag', title: '新品特价', name: "新品特价", image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/home/1/1-01.png'},
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
            {id: "7ab47ac9f2256030ff52f17f25f23fe8", type: 'Product', title: '露露名器', image: 'http://blsm-public.oss.aliyuncs.com/images/20140603/2-01.png'},
            {id: "8c41638d5086aac446df111fe21e184e", type: 'Product', title: '指蝶精灵', image: 'http://blsm-public.oss.aliyuncs.com/images/20140603/2-02.png'},
            {id: "f1dfc05cd2028142a7dbe8a00eb8d353", type: 'Product', title: 'joker O环', image: 'http://blsm-public.oss.aliyuncs.com/images/20140603/2-03.png'},
            {id: "2f69ab1db00db6e978732055365f3831", type: 'Product', title: '甜心奶瓶', image: 'http://blsm-public.oss.aliyuncs.com/images/20140603/2-04.png'},
            {id: "f9f72abc253bd1579682b84839982e31", type: 'Product', title: '延时锻炼器', image: 'http://blsm-public.oss.aliyuncs.com/images/20140603/2-05.png'}
          ]
        },
        {
          name: "精品汇",
          objects: [
            {id: "ef7c1cd19f87017abf7f39b9c92c545c", type: 'Article', title: '', image: 'http://blsm-public.oss.aliyuncs.com/images/20140530/huodong-2.png'},
            {id: "c140db5556eabea468a2a2ac4a9f9100", type: 'Product', title: '缩阴按摩器', image: 'http://blsm-public.oss.aliyuncs.com/images/20140603/2-06.png'},
            {id: "5c63fd0f84693868b93daf1700769c51", type: 'Product', title: '朵芬五跳蛋', image: 'http://blsm-public.oss.aliyuncs.com/images/20140603/2-07.png'},
            {id: "a88349b5b42bdafd74f6fdcf97df5f31", type: 'Product', title: '黑魂名器', image: 'http://blsm-public.oss.aliyuncs.com/images/20140603/2-08.png'},
            {id: "9105e2f3bec747c232ed52d7b3d266b0", type: 'Product', title: '锁精震动环', image: 'http://blsm-public.oss.aliyuncs.com/images/20140603/2-09.png'},
            {id: "6037bc1bb92639060d5e6e0ec967fea2", type: 'Product', title: 'G点探花', image: 'http://blsm-public.oss.aliyuncs.com/images/20140603/2-10.png'}
          ]
        },
        {
          name: "新婚初夜装",
          objects: [
            {id: "", type: 'Tag', title: '新婚初夜装', image: 'http://blsm-public.oss.aliyuncs.com/images/20140530/huodong-3.png'},
            {id: "f97cf00abc13c595f567fe2d2d945f63", type: 'Product', title: '性感吊带', image: 'http://blsm-public.oss.aliyuncs.com/images/20140530/2-11.png'},
            {id: "79c4cbc23fd55979f844904b8e7f5e12", type: 'Product', title: '蕾丝吊带', image: 'http://blsm-public.oss.aliyuncs.com/images/20140530/2-12.png'},
            {id: "a1552a24353c5bed92a6f6b988193c97", type: 'Product', title: '性感长筒袜', image: 'http://blsm-public.oss.aliyuncs.com/images/20140530/2-13.png'},
            {id: "efd72bf7387bf19b4707c7936f63a875", type: 'Product', title: '豹纹T裤', image: 'http://blsm-public.oss.aliyuncs.com/images/20140526/2-14.png'},
            {id: "4d3e3d92d7a291d82845e125fd796331", type: 'Product', title: '女警察制服', image: 'http://blsm-public.oss.aliyuncs.com/images/20140603/2-15.png'}
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

  get :notifications, jbuilder: 'welcome/notification' do
    @notifications = [
      {id: 1, title: '测试通知第1条', description: "测试的内容哦", image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/majia/1/1-01.png', url: "http://www.baidu.com", apk_sign: "com.blsm.hehe"},
      {id: 2, title: '测试通知第2条', description: "妈妈说很好", image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/majia/1/1-01.png', url: "http://www.baidu.com", apk_sign: "com.blsm.hehe"},
      {id: 3, title: '测试通知第3条', description: "爸爸也说很好", image: 'http://blsm-public.oss.aliyuncs.com/images/20140509/majia/1/1-01.png', url: "http://www.baidu.com", apk_sign: "com.blsm.hehe"},
    ]
  end

end
