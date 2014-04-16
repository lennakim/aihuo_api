class Welcome < Grape::API

  params do
    optional :date, type: Integer, desc: "Device created date."
  end
  get :home, jbuilder: 'welcome/home' do
    current_application
    @banners = @application.articles.banner
    # @tags = Tag.where(id: Tag::CATEGORIES)
    @submenus = [
      {id: 101, type: 'Tag', name: '最热', image: 'http://test8811609.oss.aliyuncs.com/amap/6.jpg'},
      {id: 101, type: 'SecondKill', image: 'http://test8811609.oss.aliyuncs.com/amap/6.jpg', start_time: "2014-04-01T20:38:56+08:00", end_time: "2014-04-02T20:38:56+08:00"},
      {id: 101, type: 'Tag', name: '火爆涛涛', image: 'http://test8811609.oss.aliyuncs.com/amap/6.jpg'}
    ]
    @categories = [
      {id: 101, name: "男用", image: 'http://test8811609.oss.aliyuncs.com/amap/6.jpg'},
      {id: 101, name: "男用", image: 'http://test8811609.oss.aliyuncs.com/amap/6.jpg'},
      {id: 101, name: "男用", image: 'http://test8811609.oss.aliyuncs.com/amap/6.jpg'},
      {id: 101, name: "男用", image: 'http://test8811609.oss.aliyuncs.com/amap/6.jpg'},
      {id: 101, name: "男用", image: 'http://test8811609.oss.aliyuncs.com/amap/6.jpg'},
      {id: 101, name: "男用", image: 'http://test8811609.oss.aliyuncs.com/amap/6.jpg'}
    ]
    @sections = [
      {
        name: "热销区",
        objects: [
          {id: 100, type: 'Article', title: '', image: 'http://test8811609.oss.aliyuncs.com/amap/6.jpg'},
          {id: 101, type: 'Product', title: '产品名称', image: 'http://test8811609.oss.aliyuncs.com/amap/5.jpg'},
          {id: 102, type: 'Product', title: '产品名称', image: 'http://test8811609.oss.aliyuncs.com/amap/4.jpg'},
          {id: 103, type: 'Product', title: '产品名称', image: 'http://test8811609.oss.aliyuncs.com/amap/3.jpg'},
          {id: 104, type: 'Product', title: '产品名称', image: 'http://test8811609.oss.aliyuncs.com/amap/2.jpg'},
          {id: 105, type: 'Product', title: '产品名称', image: 'http://test8811609.oss.aliyuncs.com/amap/1.jpg'}
        ]
      },
      {
        name: "新品区",
        objects: [
          {id: 100, type: 'Article', title: '', image: 'http://test8811609.oss.aliyuncs.com/amap/6.jpg'},
          {id: 101, type: 'Product', title: '产品名称', image: 'http://test8811609.oss.aliyuncs.com/amap/5.jpg'},
          {id: 102, type: 'Product', title: '产品名称', image: 'http://test8811609.oss.aliyuncs.com/amap/4.jpg'},
          {id: 103, type: 'Product', title: '产品名称', image: 'http://test8811609.oss.aliyuncs.com/amap/3.jpg'},
          {id: 104, type: 'Product', title: '产品名称', image: 'http://test8811609.oss.aliyuncs.com/amap/2.jpg'},
          {id: 105, type: 'Product', title: '产品名称', image: 'http://test8811609.oss.aliyuncs.com/amap/1.jpg'}
        ]
      },
      {
        name: "主题馆",
        objects: [
          {id: 100, type: 'Product', title: '', image: 'http://test8811609.oss.aliyuncs.com/amap/6.jpg'},
          {id: 101, type: 'Product', title: '￥89.7', image: 'http://test8811609.oss.aliyuncs.com/amap/5.jpg'},
          {id: 102, type: 'Product', title: '￥89.7', image: 'http://test8811609.oss.aliyuncs.com/amap/4.jpg'},
          {id: 103, type: 'Product', title: '￥89.7', image: 'http://test8811609.oss.aliyuncs.com/amap/3.jpg'},
          {id: 104, type: 'Product', title: '￥89.7', image: 'http://test8811609.oss.aliyuncs.com/amap/2.jpg'},
          {id: 105, type: 'Product', title: '￥89.7', image: 'http://test8811609.oss.aliyuncs.com/amap/1.jpg'}
        ]
      }
    ]
    @brands = [
      [1, "杜蕾斯", "http://test8811609.oss.aliyuncs.com/amap/brand.jpg"],
      [2, "杰士邦", "http://test8811609.oss.aliyuncs.com/amap/brand.jpg"],
      [3, "杜蕾斯", "http://test8811609.oss.aliyuncs.com/amap/brand.jpg"],
      [4, "呵呵哈", "http://test8811609.oss.aliyuncs.com/amap/brand.jpg"]
    ]
    # cache(key: [:v2, :home, @banners.last], expires_in: 2.days) do
    #   @banners
    #   @tags
    # end
  end

end
