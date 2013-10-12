class API < Grape::API
  version 'v2', using: :path
  prefix 'api'

  format :json
  formatter :json, Grape::Formatter::Jbuilder

  mount Mobile::Welcome
  mount Mobile::Articles
end
