namespace :cache do
  desc "clear specify cache"
  task :clear => :environment do
    Rails.cache.clear
  end
end
