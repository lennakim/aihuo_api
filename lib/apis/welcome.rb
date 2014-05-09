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
  end
  get :home, jbuilder: 'welcome/home' do
    current_application
    @banners = @application.articles.banner
    # @tags = Tag.where(id: Tag::CATEGORIES)
    if hide_gift_products?
      @submenus = [
        {id: "", type: 'Tag', title: '新品特价', name: "男用", image: 'http://blsm-public.oss.aliyuncs.com/images/20140428/v2home/1/01-1.png'},
        {id: "", type: 'Tag', title: '新品特价', name: "男用", image: 'http://blsm-public.oss.aliyuncs.com/images/20140428/v2home/1/01-1.png'},
        {id: "", type: 'Tag', title: '激情爱全套', name: "男用", image: 'http://blsm-public.oss.aliyuncs.com/images/20140428/v2home/1/01-3.png'}
      ]
    else
      @submenus = [
        {id: "", type: 'Tag', title: '新品特价', name: "男用", image: 'http://blsm-public.oss.aliyuncs.com/images/20140428/v2home/1/01-1.png'},
        {id: "", type: 'Tag', title: '0元购', name: "男用", image: 'http://blsm-public.oss.aliyuncs.com/images/20140428/v2home/1/01-2.png'},
        {id: "", type: 'Tag', title: '激情爱全套', name: "男用", image: 'http://blsm-public.oss.aliyuncs.com/images/20140428/v2home/1/01-3.png'}
      ]
    end
    @categories = [
      {id: "", type: 'Tag', title: '男士专区', name: "男用", image: 'http://blsm-public.oss.aliyuncs.com/images/20140428/v2home/3/fenlei-01.png'},
      {id: "", type: 'Tag', title: '女士专区', name: "女用", image: 'http://blsm-public.oss.aliyuncs.com/images/20140428/v2home/3/fenlei-02.png'},
      {id: "", type: 'Tag', title: '性感服饰', name: "更多情趣", image: 'http://blsm-public.oss.aliyuncs.com/images/20140428/v2home/3/fenlei-03.png'},
      {id: "", type: 'Tag', title: '助情助兴', name: "最近有点烦", image: 'http://blsm-public.oss.aliyuncs.com/images/20140428/v2home/3/fenlei-04.png'},
      {id: "", type: 'Tag', title: '夫妻情侣', name: "高潮迭起", image: 'http://blsm-public.oss.aliyuncs.com/images/20140428/v2home/3/fenlei-05.png'},
      {id: "", type: 'Tag', title: '套套润滑', name: "日常战备", image: 'http://blsm-public.oss.aliyuncs.com/images/20140428/v2home/3/fenlei-06.png'}
    ]
    @sections = [
      {
        name: "热销区",
        objects: [
          {id: "", type: 'Tag', title: '新品特价', image: 'http://blsm-public.oss.aliyuncs.com/images/20140428/v2home/2/02-1/huodong-01.png'},
          {id: "4e0d1282868113aed2ebfe4341a61d85", type: 'Product', title: '免提飞机杯', image: 'http://blsm-public.oss.aliyuncs.com/images/20140428/v2home/2/02-1/02-01.png'},
          {id: "2ade7cbb1f300ada6eb197b23f79eb49", type: 'Product', title: '延时喷剂', image: 'http://blsm-public.oss.aliyuncs.com/images/20140428/v2home/2/02-1/02-02.png'},
          {id: "90a290d805341b81a0493af54b2a1e6e", type: 'Product', title: 'G点跳蛋', image: 'http://blsm-public.oss.aliyuncs.com/images/20140428/v2home/2/02-1/02-03.png'},
          {id: "f1dfc05cd2028142a7dbe8a00eb8d353", type: 'Product', title: 'jokerO环', image: 'http://blsm-public.oss.aliyuncs.com/images/20140428/v2home/2/02-1/02-04.png'},
          {id: "de90921e6090ce02aca4835906703b84", type: 'Product', title: '花语转珠棒', image: 'http://blsm-public.oss.aliyuncs.com/images/20140428/v2home/2/02-1/02-05.png'}
        ]
      },
      {
        name: "新品区",
        objects: [
          {id: "4a2b31e0ac84a2441dc009d12b6f08ee", type: 'Article', title: '', image: 'http://blsm-public.oss.aliyuncs.com/images/20140428/v2home/2/02-2/huodong-02.png'},
          {id: "2fbdd85ffba11935d0df4e6ca0c5cb8f", type: 'Product', title: '唯美AV棒', image: 'http://blsm-public.oss.aliyuncs.com/images/20140428/v2home/2/02-2/02-06.png'},
          {id: "f96ff6f6035d482f6df52a2c844590a6", type: 'Product', title: '高潮缩阴', image: 'http://blsm-public.oss.aliyuncs.com/images/20140428/v2home/2/02-2/02-07.png'},
          {id: "4fa540b3fadff80e5d9f9bf27874b2f6", type: 'Product', title: 'MP3跳蛋', image: 'http://blsm-public.oss.aliyuncs.com/images/20140428/v2home/2/02-2/02-08.png'},
          {id: "cffb921886b1ebbec8f27f49834144bb", type: 'Product', title: '高潮按摩棒', image: 'http://blsm-public.oss.aliyuncs.com/images/20140428/v2home/2/02-2/02-09.png'},
          {id: "a19dab79f46393a75711193d98854390", type: 'Product', title: '缩阴高潮', image: 'http://blsm-public.oss.aliyuncs.com/images/20140428/v2home/2/02-2/02-10.png'}
        ]
      },
      {
        name: "主题馆",
        objects: [
          {id: "a59997020868a40e1252db47a47fa6c5", type: 'Article', title: '', image: 'http://blsm-public.oss.aliyuncs.com/images/20140428/v2home/2/02-3/huodong-03.png'},
          {id: "26b0dbc00cd4fa4d920ffe5fcc5cab7f", type: 'Product', title: '深V露乳', image: 'http://blsm-public.oss.aliyuncs.com/images/20140428/v2home/2/02-3/02-11.png'},
          {id: "9cfafcd46346ae14ef0b42539db6c062", type: 'Product', title: '诱惑套装', image: 'http://blsm-public.oss.aliyuncs.com/images/20140428/v2home/2/02-3/02-12.png'},
          {id: "7163f18ab7de9a11d20085e20ee338fc", type: 'Product', title: '露乳诱惑', image: 'http://blsm-public.oss.aliyuncs.com/images/20140428/v2home/2/02-3/02-13.png'},
          {id: "f9a19ed8c65f3523397074492bc82e23", type: 'Product', title: '制服学生', image: 'http://blsm-public.oss.aliyuncs.com/images/20140428/v2home/2/02-3/02-14.png'},
          {id: "4d3e3d92d7a291d82845e125fd796331", type: 'Product', title: '军官制服', image: 'http://blsm-public.oss.aliyuncs.com/images/20140428/v2home/2/02-3/02-15.png'}
        ]
      }
    ]
    @brands = [
      {id: nil, type: 'Tag', title: '杜蕾斯', image: "http://blsm-public.oss.aliyuncs.com/images/20140428/v2home/4/pinpai-01.png"},
      {id: nil, type: 'Tag', title: '诺兰', image: "http://blsm-public.oss.aliyuncs.com/images/20140428/v2home/4/pinpai-02.png"},
      {id: nil, type: 'Tag', title: '名流', image: "http://blsm-public.oss.aliyuncs.com/images/20140428/v2home/4/pinpai-03.png"},
      {id: nil, type: 'Tag', title: '尚牌', image: "http://blsm-public.oss.aliyuncs.com/images/20140428/v2home/4/pinpai-04.png"}
    ]
    # cache(key: [:v2, :home, @banners.last], expires_in: 2.days) do
    #   @banners
    #   @tags
    # end
  end

end
