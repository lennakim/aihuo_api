# Exploring Concerns for Rails 4
# http://blog.andywaite.com/2012/12/23/exploring-concerns-for-rails-4/
# http://richonrails.com/articles/rails-4-code-concerns-in-active-record-models#.UmduaCSezDc
require "configuration"
module CarrierWave
  extend ActiveSupport::Concern

  class << self
    include CarrierWave::Configuration
    def configure(&block)
      yield self
    end
  end

  def store_host
    "http://" + CarrierWave.aliyun_host
  end

  def store_dir(column)
    "/uploads/#{self.class.to_s.underscore}/#{column.to_s}/#{self.id}/"
  end

  # version :list, :grid, :retain
  # path :url, :path
  # def store_dir
  #   "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  # end
  def carrierwave_image(version, path)
    store_host + store_dir(:image) + version.to_s + '_' + image
  end

  # version :list, :grid, :retain
  # path :url, :path
  # def store_dir
  #   "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  # end
  def carrierwave_background(version, path)
    store_host + store_dir(:background) + version.to_s + '_' + background
  end

end
