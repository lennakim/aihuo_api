# 初始化时加载路径 app/app app/api app/views app/models app/concerns
%w[app api models views concerns].each do |folder|
  $LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'app', folder))
end
$LOAD_PATH.unshift(File.dirname(__FILE__))

# 初始化时加载 boot, require Gemfile 里面的 gem
require 'boot'

# 设定 Server 运行在什么环境下
# bundle exec thin start -R config.ru -e $RACK_ENV -p $PORT
# http://www.modrails.com/documentation/Users%20guide%20Nginx.html#RackEnv
Bundler.require :default, ENV['RACK_ENV']

# 建立数据库连接
environment =  ENV['RACK_ENV']
dbconfig = YAML.load(ERB.new(File.read('config/database.yml')).result)[environment]
ActiveRecord::Base.establish_connection(dbconfig)
# ActiveRecord::Base.logger = Logger.new(STDERR)
ActiveRecord::Base.logger = Logger.new('log/database.log')
ActiveSupport::LogSubscriber.colorize_logging = false

# 初始化时加载所有 initializers 文件夹内的文件
Dir[File.expand_path('../initializers/*.rb', __FILE__)].each { |f| require f }

# 初始化时加载所有 app 文件夹内的文件
Dir[File.expand_path('../../app/concerns/*.rb', __FILE__)].each { |f| require f }
Dir[File.expand_path('../../app/api/*.rb', __FILE__)].each { |f| require f }
Dir[File.expand_path('../../app/models/*.rb', __FILE__)].each { |f| require f }

# ShamanCache.config.cache = ActiveSupport::Cache::FileStore.new("tmp/cache")

require "api"
require "app"
