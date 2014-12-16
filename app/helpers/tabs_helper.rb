module TabsHelper
  extend Grape::API::Helpers
  
  def tabs_cacke_key
    [:v2, :tabs, params[:api_key]]
  end
end