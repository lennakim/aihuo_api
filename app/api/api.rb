# Need to require other api controllers at first.
require 'welcome'
require 'products'
require 'articles'
require 'messages'
module ShouQuShop
  class API < Grape::API
    version 'v2', using: :path
    prefix 'api'

    format :json
    formatter :json, Grape::Formatter::Jbuilder

    mount ::API::Welcome
    mount ::API::Products
    mount ::API::Articles
    mount ::API::Messages
  end
end
