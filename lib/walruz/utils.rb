module Walruz
  module Utils
    
    def orP(*policies)
      clazz = Class.new(Walruz::Policy) do
        
        def self.policies=(p)
          @policies = p
        end
        
        def self.policies
          @policies
        end
        
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
      Class.new(Walruz::Policy) do
        
        def authorized?(actor, subject)
          acum = [true, {}]
          policies.each do |policy|
            break unless acum[0]
            result = Array(policy.new.authorized?(actor, subject))
            acum[0] &&= result[0]
            acum[1].merge(result[1]) unless result[1].nil?
          end
          acum[0] ? acum : acum[0]
        end
        
      end
    end
    
    def notP(policy)
      Class.new(Walruz::Policy) do
        
        def authorized?(actor, subject)
          result = policy.new.authorized?(actor, subject)
          !result[0]
        end
        
      end
    end
    
    module_function(:orP, :andP, :notP) 
    
  end
end