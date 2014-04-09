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
    combination_url(:image, version)
  end

  # version :list, :grid, :retain
  # path :url, :path
  # def store_dir
  #   "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  # end
  def carrierwave_background(version, path)
    combination_url(:background, version)
  end

  private

    def combination_url(type, version)
      if version
        store_host + store_dir(type) + version.to_s + '_' + send(type)
      else
        store_host + store_dir(type) + send(type)
      end
    end

end
