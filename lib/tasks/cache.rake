namespace :cache do
  desc "clear specify cache"
  task :clear, [:type] => [:environment] do |t, args|
    type = args[:type]
    Rails.cache.delete_matched "#{type}-*"
  end
end
