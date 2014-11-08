module MemcachedHelper
  extend Grape::API::Helpers

  def incr_value_in_memcached(index_key, key)
    Rails.cache.dalli.with do |client|
      client.add(index_key, key, 0, raw: true)
      if client.add(key, 1, 0, raw: true)
        client.append(index_key, ",#{key}")
      else
        client.incr key
        keys = client.get(index_key).split(',')
        client.append(index_key, ",#{key}") unless keys.include? key
      end
    end
  end

end
