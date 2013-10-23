module CarrierWave
  module Configuration
    extend ActiveSupport::Concern

    included do
      add_config :aliyun_bucket
      add_config :aliyun_host
    end

    module ClassMethods
      # Just copy the method code form here.
      # https://github.com/carrierwaveuploader/carrierwave/blob/master/lib/carrierwave/uploader/configuration.rb
      # https://github.com/huacnlee/carrierwave-aliyun/blob/master/lib/carrierwave/aliyun/configuration.rb
      def add_config(name)
        class_eval <<-RUBY, __FILE__, __LINE__ + 1

          def self.#{name}(value=nil)
            @#{name} = value if value
            return @#{name} if self.object_id == #{self.object_id} || defined?(@#{name})
            name = superclass.#{name}
            return nil if name.nil? && !instance_variable_defined?("@#{name}")
            @#{name} = name && !name.is_a?(Module) && !name.is_a?(Symbol) && !name.is_a?(Numeric) && !name.is_a?(TrueClass) && !name.is_a?(FalseClass) ? name.dup : name
          end

          def self.#{name}=(value)
            @#{name} = value
          end

          def #{name}=(value)
            @#{name} = value
          end

          def #{name}
            value = @#{name} if instance_variable_defined?(:@#{name})
            value = self.class.#{name} unless instance_variable_defined?(:@#{name})
            if value.instance_of?(Proc)
              value.arity >= 1 ? value.call(self) : value.call
            else
              value
            end
          end

        RUBY
      end
    end
  end
end
