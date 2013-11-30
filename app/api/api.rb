# Need to require other api controllers at first.
require 'welcome'
require 'products'
require 'articles'
require 'messages'
require 'nodes'
require 'topics'
require 'replies'
require 'orders'
require 'carts'
require 'devices'
require 'device_infos'
require 'coupons'
module ShouQuShop
  class API < Grape::API
    version 'v2', using: :path
    prefix 'api'

    format :json
    formatter :json, Grape::Formatter::Jbuilder

    helpers do
      def current_application
        @application = Application.where(api_key: params[:api_key]).first
      end

      def sign
        url = ""
        secret_key = @application.secret_key
        url += request.request_method # GET or POST
        url += request.scheme # http or https
        url += "//"
        url += request.host # example: api.aihuo360.com
        url += request.path_info # example: /api/v2/home
        binding.pry
      end
    end

    mount ::API::Welcome
    mount ::API::Products
    mount ::API::Articles
    mount ::API::Messages
    mount ::API::Nodes
    mount ::API::Topics
    mount ::API::Replies
    mount ::API::Orders
    mount ::API::Carts
    mount ::API::Devices
    mount ::API::DeviceInfos
    mount ::API::Coupons
  end
end
