module Walruz

  class Config

    def self.add_authorization_query_methods_to(base)
      base.extend(Walruz::Manager::AuthorizationQuery)
      class << base
        include Walruz::Memoization
        walruz_memoize :can?, :authorize, :satisfies, :satisfies?
      end
    end

    def enable_will_paginate_extension(options = {})
      options = { :include_active_record => false }.merge!(options)
      gem 'mislav-will_paginate'
      require 'will_paginate'
      require File.expand_path(File.join(File.dirname(__FILE__),  'more', 'pagination'))

      safe_include(WillPaginate::Collection, Walruz::More::Pagination::WillPaginateCollection)
      safe_include(Array, Walruz::More::Pagination::Base)

      if options[:include_active_record]
        raise RuntimeError.new("You ask to enable Walruz extensions on ActiveRecord::Base, but it was not found. Maybe you should require 'active_record' first") unless defined?("ActiveRecord::Base")
        safe_include(ActiveRecord::Base, Walruz::More::Pagination::Base)
      end
    rescue Gem::LoadError
      raise RuntimeError.new("You ask to enable Walruz extensions on WillPaginate, but it was not found, Maybe you should require 'will_paginate' first")
    end

    def enable_array_extension
      require File.expand_path(File.join(File.dirname(__FILE__), 'core_ext', 'array'))
      safe_include(Array, Walruz::CoreExt::Array)
    end

    def actors=(actors)
      Array(actors).each do |actor|
        actor.send(:include, Walruz::Actor)
      end
    end

    def subjects=(subjects)
      Array(subjects).each do |subject|
        subject.send(:include, Walruz::Subject)
      end
    end

    protected

    def safe_include(base, module_to_include)
      return if base.included_modules.include?(module_to_include)
      base.send(:include, module_to_include)
    end

  end

end
