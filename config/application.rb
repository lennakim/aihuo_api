# 初始化时加载路径 lib/app lib/api lib/views lib/models lib/concerns
%w[app apis models views concerns].each do |folder|
  $LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib', folder))
end
$LOAD_PATH.unshift(File.dirname(__FILE__))

# 初始化时加载 boot, require Gemfile 里面的 gem
require 'boot'

# 设定 Server 运行在什么环境下
# bundle exec thin start -R config.ru -e $RACK_ENV -p $PORT
# http://www.modrails.com/documentation/Users%20guide%20Nginx.html#RackEnv
Bundler.require :default, ENV['RACK_ENV']

# 建立数据库连接
environment = ENV['RACK_ENV']
dbconfig = YAML.load(ERB.new(File.read('config/database.yml')).result)[environment]
ActiveRecord::Base.establish_connection(dbconfig)
# ActiveRecord::Base.logger = Logger.new(STDERR)
ActiveRecord::Base.logger = Logger.new('log/database.log')
ActiveSupport::LogSubscriber.colorize_logging = false
if environment == 'production'
  ActiveRecord::Base.logger.level = Logger::INFO
end

# 初始化时加载所有 initializers 文件夹内的文件
Dir[File.expand_path('../initializers/*.rb', __FILE__)].each { |f| require f }

# 初始化时加载所有 lib 文件夹内的文件
Dir[File.expand_path('../../lib/concerns/*.rb', __FILE__)].each { |f| require f }
Dir[File.expand_path('../../lib/apis/*.rb', __FILE__)].each { |f| require f }
Dir[File.expand_path('../../lib/models/*.rb', __FILE__)].each { |f| require f }

Grape::ShamanCache.configure do |config|
  config.cache = ActiveSupport::Cache::FileStore.new("tmp/cache")
end

# [deprecated] I18n.enforce_available_locales will default to true in the future.
# If you really want to skip validation of your locale you can set I18n.
# enforce_available_locales = false to avoid this message.
I18n.enforce_available_locales = false

require "api"
require "app"
