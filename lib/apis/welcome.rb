class Welcome < Grape::API

  params do
    optional :date, type: Integer, desc: "Device created date."
  end
  get :home, jbuilder: 'welcome/home' do
    current_application
    @banners = @application.articles.banner
    # @tags = Tag.where(id: Tag::CATEGORIES)
    @submenus = [
      {id: "18dc49500bd3f544f78c56598b1400a1", type: 'Product', name: '芳心康乐宝 液体避孕套', image: 'http://blsm-public.oss.aliyuncs.com/images/20140423/240_240/01.png'},
      {id: "", type: 'Tag', name: '0元购', image: 'http://blsm-public.oss.aliyuncs.com/images/20140423/240_240/02.png'},
      {id: "0085e5f094b65336a0ca52f683b49480", type: 'Product', name: '8合1罐装24只装', image: 'http://blsm-public.oss.aliyuncs.com/images/20140423/240_240/03.png'}
    ]
    @categories = [
      {id: "", type: 'Tag', title: "男用", image: 'http://blsm-public.oss.aliyuncs.com/images/20140423/fenlei/01.png'},
      {id: "", type: 'Tag', title: "女用", image: 'http://blsm-public.oss.aliyuncs.com/images/20140423/fenlei/02.png'},
      {id: "", type: 'Tag', title: "更多情趣", image: 'http://blsm-public.oss.aliyuncs.com/images/20140423/fenlei/03.png'},
      {id: "", type: 'Tag', title: "最近有点烦", image: 'http://blsm-public.oss.aliyuncs.com/images/20140423/fenlei/04.png'},
      {id: "", type: 'Tag', title: "高潮迭起", image: 'http://blsm-public.oss.aliyuncs.com/images/20140423/fenlei/05.png'},
      {id: "", type: 'Tag', title: "日常战备", image: 'http://blsm-public.oss.aliyuncs.com/images/20140423/fenlei/06.png'}
    ]
    @sections = [
      {
        name: "热销区",
        objects: [
          {id: "", type: 'Tag', title: '新品特价', image: 'http://blsm-public.oss.aliyuncs.com/images/20140423/01/01.png'},
          {id: "9988950389e86e671d09343c5975e88b", type: 'Product', title: '硅胶隐形文胸', image: 'http://blsm-public.oss.aliyuncs.com/images/20140423/01/01-zqf_3504.png'},
          {id: "53302f048a6cdc0a89b4fdc3f1d5608a", type: 'Product', title: 'selebritee性感开档连裤袜', image: 'http://blsm-public.oss.aliyuncs.com/images/20140423/01/02-sq_3830.png'},
          {id: "66d9165b20475b299359b6a73de1c384", type: 'Product', title: '日本JOKER延时喷剂', image: 'http://blsm-public.oss.aliyuncs.com/images/20140423/01/03-sq_2462.png'},
          {id: "91c9772665b17a9a85efb9ec92699643", type: 'Product', title: '开档露乳短裙8821粉色', image: 'http://blsm-public.oss.aliyuncs.com/images/20140423/01/04-sq_3865.png'},
          {id: "e0367fb542c80ef95b8a17548bf22ba1", type: 'Product', title: '樱桃香氛-85ml-经济装', image: 'http://blsm-public.oss.aliyuncs.com/images/20140423/01/05-sq_3804.png'}
        ]
      },
      {
        name: "新品区",
        objects: [
          {id: "", type: 'Tag', title: '天天平价', image: 'http://blsm-public.oss.aliyuncs.com/images/20140423/02/02.png'},
          {id: "6234743c90f5bc8eb6f18f0e334b084f", type: 'Product', title: 'G点阴蒂乳头调情跳蛋', image: 'http://blsm-public.oss.aliyuncs.com/images/20140423/02/01-sq_3727.png'},
          {id: "ee228024aa64b06c3eff06f7851d1281", type: 'Product', title: '动漫名器-处女学生妹', image: 'http://blsm-public.oss.aliyuncs.com/images/20140423/02/02-sq_3723.png'},
          {id: "ec46e4d35f6ccdf7994777f85cb928d6", type: 'Product', title: '本草堂男用喷剂', image: 'http://blsm-public.oss.aliyuncs.com/images/20140423/02/03-sq_3766.png'},
          {id: "d849d3af1650487d67d7417ff1f6ba08", type: 'Product', title: '雷霆蝶恋花转珠棒', image: 'http://blsm-public.oss.aliyuncs.com/images/20140423/02/04-zqf_3610.png'},
          {id: "2ade7cbb1f300ada6eb197b23f79eb49", type: 'Product', title: '倍耐力 喷剂 浓缩型 15ml', image: 'http://blsm-public.oss.aliyuncs.com/images/20140423/02/05-zqf_3824.png'}
        ]
      },
      {
        name: "主题馆",
        objects: [
          {id: "442639a2be8cab91dc69922086bbdff9", type: 'Article', title: '100件抢完算', image: 'http://blsm-public.oss.aliyuncs.com/images/20140423/03/03.png'},
          {id: "6f0b512c84bc89aa2c2e067ce47d5df7", type: 'Product', title: '旋风情人二代全自动飞机杯', image: 'http://blsm-public.oss.aliyuncs.com/images/20140423/03/01-sq_3675.png'},
          {id: "25ac52b0efdafca460d8f5aa7231f1a5", type: 'Product', title: '30分钟持久润滑', image: 'http://blsm-public.oss.aliyuncs.com/images/20140423/03/02-sq_4006.png'},
          {id: "633911b204bea99e5e158646cad32344", type: 'Product', title: '爱全套48只八合一', image: 'http://blsm-public.oss.aliyuncs.com/images/20140423/03/03-sq_3960.png'},
          {id: "a19dab79f46393a75711193d98854390", type: 'Product', title: '诺兰缩阴球', image: 'http://blsm-public.oss.aliyuncs.com/images/20140423/03/03-zqf_3416.png'},
          {id: "710463cb63bb4353d581cc2c69e4692a", type: 'Product', title: '体验真正纯真处女萝莉', image: 'http://blsm-public.oss.aliyuncs.com/images/20140423/03/05-sq_3724.png'}
        ]
      }
    ]
    @brands = [
      {id: nil, type: 'Tag', title: '杜蕾斯', image: "http://blsm-public.oss.aliyuncs.com/images/20140423/pinpai/du'lei'si.png"},
      {id: nil, type: 'Tag', title: '名流', image: "http://blsm-public.oss.aliyuncs.com/images/20140423/pinpai/mign'liu.png"},
      {id: nil, type: 'Tag', title: '诺兰', image: "http://blsm-public.oss.aliyuncs.com/images/20140423/pinpai/nuo'lan.png"},
      {id: nil, type: 'Tag', title: '尚牌', image: "http://blsm-public.oss.aliyuncs.com/images/20140423/pinpai/shang'pai.png"}
    ]
    # cache(key: [:v2, :home, @banners.last], expires_in: 2.days) do
    #   @banners
    #   @tags
    # end
  end

end
