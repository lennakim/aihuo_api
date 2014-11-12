require 'digest/md5'

class API < Grape::API
  include Grape::ShamanCache
  include Grape::Kaminari

  version 'v2', using: :path
  # prefix 'api'

  format :json
  # formatter :json, GrapeJbuilderFormatter
  formatter :json, Grape::Formatter::Jbuilder

  helpers do
    # example:
    # log.info "something" can be found in log/puma.out.log
    def log
      API.logger
    end

    def current_application
      api_key = request.headers['Apikey'] || params[:api_key]
      @application = Application.where(api_key: api_key).first
      error!({ error: 'Unknown API KEY' }, 500) unless @application
    end

    def current_device
      @device = Device.where(device_id: params[:device_id]).first_or_create!
    end

    def flatten_hash(hash)
      hash.map do |k, v|
        if v.is_a?(Hash)
          # When upload a file, make tempfile and other params out of hash.
          v.key?('tempfile') ? "#{k}=#{v['filename']}" : flatten_hash(v)
        else
          "#{k}=#{v}"
        end
      end
    end

    def url_encode(s)
      s.to_s.dup.force_encoding('ASCII-8BIT').gsub(/[^a-zA-Z0-9_\-.\*]/) do
        sprintf('%%%02X', $&.unpack('C')[0])
      end
    end

    def print_sign(string)
      log.info "string: #{string}"
      log.info "sign: #{Digest::MD5.hexdigest(url_encode(string))}"
    end

    def sign(hash_signature, signature_keys)
      # Remove the "sign" entry
      signature_keys.each { |key| hash_signature.delete(key) }

      calculated_signature = flatten_hash(hash_signature).flatten.sort.join

      base_url = request.request_method
      base_url += "#{request.scheme}://#{request.host}#{request.path_info}"

      # Getting secret key of current application
      current_application
      return unless @application
      secret_key = @application.secret_key

      # Final calculated_signature to compare against
      string = base_url + calculated_signature + secret_key
      print_sign(string)
      Digest::MD5.hexdigest(url_encode(string))
    end

    def sign_approval?(signature_keys = ['sign', :sign])
      hash_signature = declared(params, include_missing: false)
      sign(hash_signature, signature_keys).eql? params[:sign]
    end

    def verify_sign
      error!('Access Denied', 401) unless sign_approval?
    end

    def authenticate?
      member = Member.find params[:member_id]
      member && member.authenticate?(params[:password])
    end
  end

  after do
    # http://codetunes.com/2014/grape-part-II/
    log_foramt = "[#{status}] - "
    log_foramt += "#{request.request_method} \"#{request.fullpath}\" - "
    # log_foramt += "#{request.env['HTTP_APIKEY']} - "
    # log_foramt += "#{request.env['HTTP_DEVICE_ID']}"
    log_foramt += "#{request.headers['Apikey']} - "
    log_foramt += "#{request.headers['Device-Id']}"
    log.info log_foramt
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
