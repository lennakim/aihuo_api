# Need to require other api controllers at first.
require 'welcome'
require 'products'
require 'articles'
require 'messages'
require 'nodes'
require 'topics'
require 'replies'
require 'orders'
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
    mount ::API::Nodes
    mount ::API::Topics
    mount ::API::Replies
    mount ::API::Orders
  end
end
