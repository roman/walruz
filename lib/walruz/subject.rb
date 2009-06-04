module Walruz
  module Subject
    
    def self.included(base)
      base.class_eval do 
        
        def self._walruz_policies=(policies)
          @_walruz_policies = policies
        end
        
        def self._walruz_policies
          @_walruz_policies
        end
        
        extend ClassMethods
      end
    end
    
    def can_be?(label, actor)
      label  = self.class._walruz_policies.key?(label) ? label : :default
      result = Array(self.class._walruz_policies[label].new.authorized?(actor, self))
      if result[0]
        result[1]
      else
        response_params = result[1].nil? ? {} : result[1]
        error_message = response_params[:error_message] || "You are not authorized to access this content"
        raise NotAuthorized.new(error_message) 
      end
    end
    
    module ClassMethods
      
      def check_authorizations(policy_map)
        case policy_map
        when Hash
          self._walruz_policies = policy_map
        else
          self._walruz_policies = { :default => policy_map }
        end
      end
      
    end
    
  end
end