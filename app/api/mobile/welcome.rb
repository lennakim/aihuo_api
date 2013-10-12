module Mobile
  class Welcome < Grape::API
    params do
      optional :date, type: Integer, desc: "Device created date."
    end
    get :home, jbuilder: 'welcome/home' do
      if params[:date] == 20131010
        # 日期参数在3日内的显示0元购的banner
        @banners = Article.banner.with_free
      else
        # 默认显示不带0元购的banner
        @banners = Article.banner.without_free
      end
    end

  end
end
