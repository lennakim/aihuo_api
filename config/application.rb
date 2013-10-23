# 初始化时加载路径 app/api app/lib app/models
%w[api models views].each do |folder|
  $LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'app', folder))
end
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'app', 'models', 'concerns'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

# 初始化时加载 boot, require Gemfile 里面的 gem
require 'boot'

# 设定 Server 运行在什么环境下
# bundle exec thin start -R config.ru -e $RACK_ENV -p $PORT
# http://www.modrails.com/documentation/Users%20guide%20Nginx.html#RackEnv
Bundler.require :default, ENV['RACK_ENV']

environment = ENV['DATABASE_URL'] ? 'production' : 'development'

# puts "ENV['RACK_ENV'] is #{ENV['RACK_ENV']}"
# puts "ENV['DATABASE_URL'] is #{ENV['DATABASE_URL']}"
# puts "environment is #{environment}"

# Connection database first way
# DB_CONFIG = YAML.load_file(File.dirname(__FILE__) + '/database.yml')
# mysql_config = DB_CONFIG[environment]
# ActiveRecord::Base.establish_connection(mysql_config)
# Connection database second way
db = YAML.load(ERB.new(File.read('config/database.yml')).result)[environment]
ActiveRecord::Base.establish_connection(db)

# 初始化时加载所有 initializers 文件夹内的文件
Dir[File.expand_path('../initializers/*.rb', __FILE__)].each { |file| require file }

# 初始化时加载所有 app 文件夹内的文件
Dir[File.expand_path('../../app/api/*.rb', __FILE__)].each { |file| require file }
Dir[File.expand_path('../../app/models/*.rb', __FILE__)].each { |file| require file }
Dir[File.expand_path('../../app/models/concerns/*.rb', __FILE__)].each { |file| require file }
