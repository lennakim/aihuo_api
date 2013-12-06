module API
  class Welcome < Grape::API

    params do
      optional :date, type: Integer, desc: "Device created date."
    end
    get :home, jbuilder: 'welcome/home' do
      current_application
      garner.options(expires_in: 15.minutes) do
        @banners = Article.banner.without_gifts
        @tags = Tag.where(id: Tag::CATEGORIES)
      end
    end

  end
end
