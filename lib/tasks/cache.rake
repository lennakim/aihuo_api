namespace :cache do
  desc "clear specify cache"
  task :clear => :environment do
    p '正在同步广告计数'
    Rake::Task['cache:sync'].execute
    p '清除缓存'
    Rails.cache.clear
  end

  desc "从memcached中同步应用统计数据"
  task :sync => :environment do
    Rails.cache.dalli.with do |client|
      # 同步应用统计数据
      keys = client.get 'statistic_keys'
      if keys
        client.delete 'statistic_keys'
        keys = keys.split(',')
        keys.each do |key|
          count = client.get(key).to_i
          client.delete key
          date, app_id, adv_id, action = key.split(':')
          adv_statistic = AdvStatistic.by_day(date).by_app(app_id).by_advertisement(adv_id).first_or_create
          result = adv_statistic.increase_count(action, count)
          if result == true
            p "同步成功#{date}, #{app_id}, #{adv_id}, #{action}, #{count}"
          else
            p "同步失败#{key}"
          end
        end
      end

      # 同步广告列表读取数据
      keys = client.get 'advertisement_ids'
      if keys
        client.delete 'advertisement_ids'
        ids = keys.split(',')
        ids.each do |id|
          count = client.get(id).to_i
          client.delete id
          advertisement = Advertisement.find(id)
          result = advertisement.increase_view_count_from_cache(count)
          if result == true
            p "同步成功 advertisement #{id}, #{count}"
          else
            p "同步失败 advertisement #{id}"
          end
        end
      end

    end
  end
end
