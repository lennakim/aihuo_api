module ShamanCache
  extend ActiveSupport::Concern

  included do
    helpers do

      def compare_etag(etag)
        etag = Digest::SHA1.hexdigest(etag.to_s)
        error!("Not Modified", 304) if request.headers["If-None-Match"] == etag

        header "ETag", etag
      end

      # Based on actionpack/lib/action_controller/base.rb, line 1216
      def expires_in(seconds, options = {})
        cache_control = []
        cache_control << "max-age=#{seconds}"
        cache_control.delete("no-cache")
        if options[:public]
          cache_control.delete("private")
          cache_control << "public"
        else
          cache_control << "private"
        end

        # This allows for additional headers to be passed through like 'max-stale' => 5.hours
        cache_control += options.symbolize_keys.reject{|k,v| k == :public || k == :private }.map{ |k,v| v == true ? k.to_s : "#{k.to_s}=#{v.to_s}"}

        header "Cache-Control", cache_control.join(', ')
      end

      def default_expire_time
        2.hours
      end

      def shaman(opts = {}, &block)
        # HTTP Cache
        cache_key = opts[:key]

        if opts[:etag]
          cache_key += ActiveSupport::Cache.expand_cache_key(opts[:etag])
          compare_etag(opts[:etag]) # Check if client has fresh version
        end

        # Set Cache-Control
        expires_in(opts[:expires_in] || default_expire_time, public: true)

        cache = ShamanCache.config.cache
        puts cache
        puts cache_key
        # Try to fetch from server side cache
        cache.fetch(cache_key, raw: true, expires_in: opts[:expires_in]) do
          # binding.pry
          puts "1"
          block.call.to_json
        end
      end

    end
  end

  class << self
    # Set the configuration options. Best used by passing a block.
    #
    # @example Set up configuration options.
    # Garner.configure do |config|
    # config.cache = Rails.cache
    # end
    #
    # @return [Config] The configuration object.
    def configure
      block_given? ? yield(ShamanCache::Config) : ShamanCache::Config
    end
    alias :config :configure
  end

  module Config
    extend self

    # Current configuration settings.
    attr_accessor :settings

    # Default configuration settings.
    attr_accessor :defaults

    @settings = {}
    @defaults = {}

    # Define a configuration option with a default.
    #
    # @example Define the option.
    # Config.option(:cache, :default => nil)
    #
    # @param [Symbol] name The name of the configuration option.
    # @param [Hash] options Extras for the option.
    #
    # @option options [Object] :default The default value.
    def option(name, options = {})
      defaults[name] = settings[name] = options[:default]

      class_eval <<-RUBY
        def #{name}
          settings[#{name.inspect}]
        end

        def #{name}=(value)
          settings[#{name.inspect}] = value
        end

        def #{name}?
          #{name}
        end
      RUBY
    end

    # Returns the default cache store, either Rails.cache or an instance
    # of ActiveSupport::Cache::MemoryStore.
    #
    # @example Get the default cache store
    # config.default_cache
    #
    # @return [Cache] The default cache store instance.
    def default_cache
      if defined?(Rails) && Rails.respond_to?(:cache)
        Rails.cache
      else
        ::ActiveSupport::Cache::MemoryStore.new
      end
    end

    # Returns the cache, or defaults to Rails cache when running in Rails
    # or an instance of ActiveSupport::Cache::MemoryStore otherwise.
    #
    # @example Get the cache.
    # config.cache
    #
    # @return [Cache] The configured cache or a default cache instance.
    def cache
      settings[:cache] = default_cache unless settings.has_key?(:cache)
      settings[:cache]
    end

    # Sets the cache to use.
    #
    # @example Set the cache.
    # config.cache = Rails.cache
    #
    # @return [Cache] The newly set cache.
    def cache=(cache)
      settings[:cache] = cache
    end

    # Default cache options
    option(:global_cache_options, :default => {})

    # Default cache expiration time.
    option(:expires_in, :default => nil)
  end

end

# module Grape
#   module Formatter
#     # For maximum performance we are fetching string from redis and return them with no parsing at all
#     module Jbuilder
#       def self.call(object, env)
#         object.is_a?(String) ? object : MultiJson.dump(object)
#       end
#     end
#   end
# end
