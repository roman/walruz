module Walruz
  module More
    module Pagination

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

    end
  end
end
