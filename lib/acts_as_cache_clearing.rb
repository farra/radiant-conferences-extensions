module Con
  module CacheClearing

    def self.included(base)
      base.extend AddActsAsCacheClearing
    end

    module AddActsAsCacheClearing
      def acts_as_cache_clearing
        class_eval <<-END

           after_save :clear_cache

           def clear_cache
              cache = ResponseCache.new
              cache.clear
           end
        END
      end
    end

  end
end
