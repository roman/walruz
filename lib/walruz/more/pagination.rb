module Walruz
  module More
    
    # This module can be included into association like objects
    module Pagination
      
      def self.included(base)
        if base.instance_methods.include?('paginate')
          # We are talking about an already paginated element, we use WillPaginate extension instead
          base.send(:include, WillPaginate)
        else
          raise RuntimeError.new("Walruz::More::Paginate needs WillPaginate in order to work")
        end
      end

      module WillPaginateCollection

        def self.included(base)
          base.class_eval do
            attr_accessor :walruz_offset
            alias_method :next_page_without_walruz, :next_page
            alias_method :next_page, :next_page_with_walruz
          end
        end
        
        def next_page_with_walruz
          if self.walruz_offset.nil? || self.walruz_offset == 0
            next_page_without_walruz
          else
            self.current_page
          end
        end

      end
      
      module WillPaginate
        
        def authorized_paginate(actor, action, *args)
          # All the args are forwarded to WillPaginate, he knows best what to do
          options = args.last if Hash === args.last  
          offset  = options.delete(:offset) || 0
          acum = []
          while true
            paginated_collection = self.paginate(*args)
            filter_authorized_items_in_collection(actor, action, acum, paginated_collection, offset)
            if complete_authorized_items_page?(acum, paginated_collection)
              break
            else
              offset = 0
              options[:page] += 1
            end
          end
          paginated_collection.replace(acum)
        end

        protected

        def complete_authorized_items_page?(items, pcollection)
          items.size == pcollection.per_page || 
            pcollection.next_page.nil?
        end

        def filter_authorized_items_in_collection(actor, action, acum, pcollection, offset = 0)
          pcollection[offset, pcollection.size].all? do |item|
            if actor.can?(action, item)
              acum << item
              if acum.size < pcollection.per_page
                true
              else
                pcollection.walruz_offset = pcollection.index(item) + 1
                false
              end
            else
              true
            end
          end
        end

      end # WillPaginate

    end # Pagination

  end
end
