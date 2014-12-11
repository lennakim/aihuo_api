module TagsHelper
  extend Grape::API::Helpers
  
  def tab_cacke_key
    [:v2, :tab, params[:api_key]]
  end
end