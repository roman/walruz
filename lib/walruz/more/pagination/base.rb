module Walruz
  module More
    module Pagination

      module Base

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
          return if offset > pcollection.size
          pcollection[offset, pcollection.size].each_with_index do |item, i|
            if Walruz.can?(actor, action, item)
              acum << item
              unless acum.size < pcollection.per_page
                pcollection.walruz_offset = i + 1
                break
              end # unless
            end # if
          end # each_with_index
        end # filter

      end

    end
  end
end
