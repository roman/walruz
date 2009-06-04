module Walruz
  module Utils
    
    module PolicyCompositionHelper
      
      # NOTE: Not using cattr_accessor to avoid dependencies with ActiveSupport
      
      def policies=(policies)
        @policies = policies
      end
      
      def policies
        @policies
      end
      
      def policy=(policy)
        @policy = policy
      end
      
      def policy
        @policy
      end
      
    end
    
    def orP(*policies)
      clazz = Class.new(Walruz::Policy) do
        extend PolicyCompositionHelper
        
        def authorized?(actor, subject)
          result = nil
          self.class.policies.detect do |policy|
            result = Array(policy.new.authorized?(actor, subject))
            result[0]
          end
          result[0] ? result : result[0]
        end
      
      end
      clazz.policies = policies
      clazz
    end
    
    def andP(*policies)
      clazz = Class.new(Walruz::Policy) do
        extend PolicyCompositionHelper
        
        def authorized?(actor, subject)
          acum = [true, {}]
          self.class.policies.each do |policy|
            break unless acum[0]
            result = Array(policy.new.authorized?(actor, subject))
            acum[0] &&= result[0]
            acum[1].merge(result[1]) unless result[1].nil?
          end
          acum[0] ? acum : acum[0]
        end
        
      end
      clazz.policies = policies
      clazz
    end
    
    def notP(policy)
      clazz = Class.new(Walruz::Policy) do
        extend PolicyCompositionHelper
        
        def authorized?(actor, subject)
          result = self.class.policy.new.authorized?(actor, subject)
          !result[0]
        end
        
      end
      clazz.policy = policy
      clazz
    end
    
    module_function(:orP, :andP, :notP) 
    
  end
end