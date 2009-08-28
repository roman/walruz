module Walruz
  module More
    
    # This module can be included into association like objects
    module Pagination
      
      base_path = File.dirname(__FILE__)
      autoload :Base, base_path + '/pagination/base'
      autoload :WillPaginateCollection, base_path + '/pagination/will_paginate_collection'
      autoload :ViewHelper, base_path + '/pagination/view_helper'


      def self.included(base)
        if base.instance_methods.include?('paginate')
          # We are talking about an already paginated element, we use WillPaginate extension instead
          base.send(:include, Base)
        else
          raise RuntimeError.new("Walruz::More::Paginate needs WillPaginate in order to work")
        end
      end

    end # Pagination

  end
end
