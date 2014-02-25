class Welcome < Grape::API

  params do
    optional :date, type: Integer, desc: "Device created date."
  end
  get :home, jbuilder: 'welcome/home' do
    current_application
    @banners = @application.articles.banner
    @tags = Tag.where(id: Tag::CATEGORIES)
    cache(key: [:v2, :home, @banners.last], expires_in: 2.days) do
      @banners
      @tags
    end
  end

end
