# Exploring Concerns for Rails 4
# http://blog.andywaite.com/2012/12/23/exploring-concerns-for-rails-4/
# http://richonrails.com/articles/rails-4-code-concerns-in-active-record-models#.UmduaCSezDc
require "configuration"
module CarrierWaveMini
  extend ActiveSupport::Concern

  class << self
    include CarrierWaveMini::Configuration
    def configure(&block)
      yield self
    end
  end

  def store_host
    "http://" + CarrierWaveMini.aliyun_host
  end

  def store_dir(column)
    "/uploads/#{self.class.to_s.underscore}/#{column.to_s}/#{self.id}/"
  end

  def material_dir
    "/images/#{created_at.strftime('%Y%m%d')}/"
  end

  # version nil
  # path :url, :path
  def carrierwave_material(version, path)
    store_host + material_dir + send(path) unless send(path).blank?
  end

  # version :list, :grid, :retain
  # path :url, :path
  def carrierwave_image(version, path)
    combination_url(:image, version)
  end

  # version :list, :grid, :retain
  # path :url, :path
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
