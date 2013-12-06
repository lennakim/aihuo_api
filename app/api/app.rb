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

      # Check if the App wants us to pass the response along to others
      if response[1]['X-Cascade'] == 'pass'
        # static files
        request_path = env['PATH_INFO']
        @filenames.each do |path|
          response = @rack_static.call(env.merge({'PATH_INFO' => request_path + path}))
          return response if response[0] != 404
        end
      end
    end
  end
end
