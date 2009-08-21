module Walruz
  module Memoization

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods

      def memoize(*methods)
        methods.each do |method|
          self.memoize_method(method)
        end
      end

      def memoize_method(method)
        memoized = {}
        original_method = self.instance_method(method)
        self.send(:define_method, method) do |*params|
          bound_original_method = original_method.bind(self).to_proc
          if params.last.kind_of?(Symbol) && params.last == :reload
            params.pop
            memoized[[self, params]] = bound_original_method.call(*params)
          else
            memoized[[self, params]] ||= bound_original_method.call(*params)
          end
        end
      end

    end

  end
end
