# Caches the json constructed within the block passed. Has the same signature as the `cache` helper
# method in `ActionView::Helpers::CacheHelper` and so can be used in the same way.
# https://github.com/rails/jbuilder/blob/master/lib/jbuilder/jbuilder_template.rb#L51
#
# Example:
#
#   json.cache! @person.cache_key, expires_in: 10.minutes do
#     json.extract! @person, :name, :age
#   end
module Tilt
  class Jbuilder < ::Jbuilder
    def cache!(key=nil, options={}, &block)
      value = ::Rails.cache.fetch(key, options) do
        _scope { yield self }
      end

      merge! value
    end
  end
end
