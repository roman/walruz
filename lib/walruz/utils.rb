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
      
      def set_params(params = {})
        @params ||= {}
        @params.merge!(params)
      end
      
      def params
        @params
      end
      
    end
    
    def any(*policies)
      # :nodoc:
      clazz = Class.new(Walruz::Policy) do
        extend PolicyCompositionHelper
        
        # :nodoc:
        def authorized?(actor, subject)
          result = nil
          self.class.policies.detect do |policy|
            result = policy.new.safe_authorized?(actor, subject)
            result[0]
          end
          result[0] ? result : result[0]
        end
      
      end
      clazz.policies = policies
      clazz
    end
    
    def all(*policies)
      # :nodoc:
      clazz = Class.new(Walruz::Policy) do
        extend PolicyCompositionHelper
        
        # :nodoc:
        def authorized?(actor, subject)
          acum = [true, {}]
          self.class.policies.each do |policy|
            break unless acum[0]
            policy_instance = policy.new
            policy_instance.set_params(acum[1])
            result = policy_instance.safe_authorized?(actor, subject)
            acum[0] &&= result[0]
            acum[1].merge!(result[1])
          end
          acum[0] ? acum : acum[0]
        end
        
        # :nodoc:
        def self.policy_keyword
          (self.policies.map { |p| p.policy_keyword.to_s[0..-2] }.join('_and_') + "?").to_sym
        end
        
      end
      clazz.policies = policies
      clazz
    end
    
    def negate(policy)
      # :nodoc:
      clazz = Class.new(Walruz::Policy) do
        extend PolicyCompositionHelper
        
        # :nodoc:
        def authorized?(actor, subject)
          result = self.class.policy.new.safe_authorized?(actor, subject)
          !result[0]
        end
        
        # :nodoc:
        def self.policy_keyword
          keyword = self.policy.policy_keyword.to_s[0..-2]
          :"not(#{keyword})?"
        end
        
      end
      clazz.policy = policy
      clazz
    end
    
    module_function(:any, :all, :negate)
    
  end
end