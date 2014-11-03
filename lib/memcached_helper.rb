module MemcachedHelper
  extend Grape::API::Helpers

  def incr_value_in_memcached(index_key, key)
    Rails.cache.dalli.with do |client|
      if client.add(key, 1, 0, raw: true)
        client.append(index_key, ",#{key}") unless client.add(index_key, key, 0, raw: true)
      else
        client.incr key
        keys = client.get(index_key).split(',')
        client.append(index_key, ",#{key}") unless keys.include? key
      end
    end
  end

end
