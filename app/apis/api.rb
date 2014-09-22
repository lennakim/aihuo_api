require 'digest/md5'
class API < Grape::API
  include Grape::ShamanCache
  # Include Grape::Kaminari module in your api
  include Grape::Kaminari

  version 'v2', using: :path
  # prefix 'api'

  format :json
  formatter :json, Grape::Formatter::Jbuilder


  helpers do
    # example:
    # log.info "something" can be found in log/api_puma.out.log
    def log
      API.logger
    end

    def current_application
      api_key = request.headers["Apikey"] || params[:api_key]
      @application = Application.where(api_key: api_key).first
      error!({error: "unknown api key"}, 500) unless @application
    end

    def current_device
      @device = Device.where(device_id: params[:device_id]).first_or_create!
    end

    def flatten_hash(hash)
      hash.collect { |k, v| v.is_a?(Hash) ? flatten_hash(v) : "#{k}=#{v}" }
    end

    def url_encode(s)
      s.to_s.dup.force_encoding("ASCII-8BIT").gsub(/[^a-zA-Z0-9_\-.\*]/) {
        sprintf("%%%02X", $&.unpack("C")[0])
      }
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

      # Final calculated_signature to compare against
      string = base_url + calculated_signature + secret_key
      log.info "string: #{string}"
      log.info "sign: #{Digest::MD5.hexdigest(url_encode(string))}"
      Digest::MD5.hexdigest(url_encode(string))
    end

    def sign_approval?(signature_keys = ['sign'])
      hash_signature = declared(params, include_missing: false)
      sign(hash_signature, signature_keys).eql? params[:sign]
    end

    def verify_sign
      error!("Access Denied", 401) unless sign_approval?
    end

    def authenticate?
      member = Member.find params[:member_id]
      member && member.authenticate?(params[:password])
    end
  end

  mount ::Welcome
  mount ::Products
  mount ::Articles
  mount ::Messages
  mount ::Nodes
  mount ::Topics
  mount ::Replies
  mount ::Orders
  mount ::Carts
  mount ::Devices
  mount ::DeviceInfos
  mount ::Members
  mount ::Coupons
  mount ::Tags
  mount ::PrivateMessages
  mount ::Contents
  mount ::Advertisements
  mount ::Tasks
end
