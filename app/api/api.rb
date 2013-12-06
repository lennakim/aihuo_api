require 'digest/md5'
require "garner/mixins/rack"
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

    # http://stackoverflow.com/questions/13675879/activerecordconnectiontimeouterror
    # https://devcenter.heroku.com/articles/concurrency-and-database-connections
    after do
      ActiveRecord::Base.connection.close
    end

    helpers do
      include Garner::Mixins::Rack

      # example:
      # logger.info "something" can be found in log/api_puma.out.log
      def logger
        API.logger
      end

      def current_application
        api_key = request.headers["Apikey"] || params[:api_key]
        @application = Application.where(api_key: api_key).first
      end

      def flatten_hash(hash)
        hash.collect { |k, v| v.is_a?(Hash) ? flatten_hash(v) : "#{k}=#{v}" }
      end

      def sign(hash_signature, signature_keys)
        # Remove the "sign" entry
        signature_keys.each do |signature_key|
          hash_signature.delete(signature_key.to_s)
          hash_signature.delete(signature_key.to_sym)
        end

        # calculated_signature = hash_signature.collect { |k, v| "#{k}=#{v}" }
        calculated_signature = flatten_hash(hash_signature)
        calculated_signature = calculated_signature.flatten.sort.join

        # example:
        # url += "GEThttp://api.aihuo360.com/api/v2/home"
        base_url = request.request_method
        base_url += "#{request.scheme}://#{request.host}#{request.path_info}"

        # Getting secret key of current application
        current_application
        return unless @application
        secret_key = @application.secret_key

        # logger.info "string: #{base_url + calculated_signature + secret_key}"
        # logger.info "sign: #{Digest::MD5.hexdigest(base_url + calculated_signature + secret_key)}"
        # Final calculated_signature to compare against
        Digest::MD5.hexdigest(base_url + calculated_signature + secret_key)
      end

      def sign_approval?(signature_keys = ['sign'])
        hash_signature = declared(params, include_missing: false)
        sign(hash_signature, signature_keys).eql? params[:sign]
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
