module ShouQuShop
  class App

    def initialize
      @filenames = [ '', '.html', 'index.html', '/index.html' ]
      @rack_static = ::Rack::Static.new(
        lambda { [404, {}, []] }, {
          :root => File.expand_path('../../public', __FILE__),
          :urls => %w[/]
        })
    end

    def self.instance
      @instance ||= Rack::Builder.new do
        run ShouQuShop::App.new
      end.to_app
    end

    def call(env)
      # api
      response = ShouQuShop::API.call(env)
    end
  end
end
