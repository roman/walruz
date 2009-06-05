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
    
    def orP(*policies)
      clazz = Class.new(Walruz::Policy) do
        extend PolicyCompositionHelper
        
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
    
    def andP(*policies)
      clazz = Class.new(Walruz::Policy) do
        extend PolicyCompositionHelper
        
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
        
      end
      clazz.policies = policies
      clazz
    end
    
    def notP(policy)
      clazz = Class.new(Walruz::Policy) do
        extend PolicyCompositionHelper
        
        def authorized?(actor, subject)
          result = self.class.policy.new.safe_authorized?(actor, subject)
          !result[0]
        end
        
      end
      clazz.policy = policy
      clazz
    end
    
    def lift_subject(key, policy, &block)
      clazz = Class.new(Walruz::Policy) do
        extend PolicyCompositionHelper
        
        def authorized?(actor, subject)
          params = self.class.params
          new_subject = subject.send(params[:key])
          result = self.class.policy.new.safe_authorized?(actor, new_subject)
          params[:callback].call(result[0], result[1], actor, subject) if params[:callback]
          result
        end
        
      end
      clazz.policy = policy
      clazz.set_params(:key => key, :callback => block)
      clazz
    end
    
    module_function(:orP, :andP, :notP, :lift_subject)
    
  end
end