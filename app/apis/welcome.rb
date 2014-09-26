class Welcome < Grape::API
  helpers WelcomeHelper

  params do
    use :home
  end
  get :home, jbuilder: 'welcome/home' do
    current_application

    cacke_key = [:v2, :home, params[:register_date], params[:filter], params[:ref], profile_number]

    cache(key: cacke_key, expires_in: 5.minutes) do
      page_for_360, page_for_authority, page_for_skin = set_homepage_data

      get_banners(params[:filter])
      case params[:filter]
      when :healthy
        get_submenus(page_for_skin)
        get_categories(nil)
        get_sections(page_for_skin)
        get_brands(nil)
      when :all
        if params[:ref] == "360"
          get_submenus(page_for_360)
        else
          get_submenus(page_for_authority)
        end
        get_categories(page_for_authority)
        get_sections(page_for_authority)
        get_brands(page_for_authority)
      end
    end
  end

  get :notifications, jbuilder: 'welcome/notification' do
    @notifications = Advertisement.all
  end

  params do
    use :channel, :ver
  end
  get :adsenses, jbuilder: 'welcome/adsenses' do
    current_application

    setting = @application.advertisement_settings.by_channel(params[:channel]).first
    @tactics = setting ? setting.tactics : []

    @advertisements = Advertisement.by_tactics(@tactics, control_volume: true)
    # HACK: '升级助手' old version client had a bug. do NOT remove next line.
    if params[:ver].blank? && @application.api_key == "7cb8ded2"
      @advertisements = @advertisements.reorder("id DESC").limit(1)
    end
    @advertisements.increase_view_count
  end

  params do
    use :channel
  end
  get :advertising_wall, jbuilder: 'welcome/adsenses' do
    current_application
    setting = @application.advertisement_settings.by_channel(params[:channel]).first
    @tactics = setting ? setting.tactics.wall : []
    @advertisements = Advertisement.by_tactics(@tactics, control_volume: false)
  end

  params do
    use :ver
  end
  get :latest_apk, jbuilder: 'welcome/latest_apk' do
    regular = /^1\.1\.\d$/
    @lasted_apk_url =
      case params[:ver]
      when regular
        { value: "http://blsm-public.oss.aliyuncs.com/downloads/lib_v1.1.0.jar", updated_at: "2014-07-15T16:42:21+08:00" }
      else
        { value: "http://blsm-public.oss.aliyuncs.com/downloads/lib_v1.0.9.jar", updated_at: "2014-07-15T16:42:21+08:00" }
      end
  end

  put "report" do
    current_application
    status = AdvApplicationReport.alert(@application.id)
    status_code = status == true ? 201 : 200
    status status_code
  end

end
