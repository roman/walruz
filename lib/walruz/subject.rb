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
    
    # 
    # See Walruz::Actor.can?
    #
    def can_be?(label, actor)
      # get_valid_label(label)
      label = if self.class._walruz_policies.key?(:default)
                self.class._walruz_policies.key?(label) ? label : :default
              else
                if self.class._walruz_policies.key?(label) 
                  label 
                else 
                  raise FlagNotFound.new(self, label)
                end
              end
      
      result = Array(self.class._walruz_policies[label].
                                return_policy.new.authorized?(actor, self))
      if result[0]
        result[1]
      else
        response_params = result[1].nil? ? {} : result[1]
        error_message = response_params[:error_message] || "You are not authorized to access this content"
        raise NotAuthorized.new(error_message) 
      end
    end
    
    module ClassMethods
      
      #
      # Stablishes the actions that can be made with a subject. You may
      # specify as many actions as you like, and also you may have a default
      # policy, that will get execute if a specified flag doesn't exist.
      # You just have to pass the action :default, or just the policy class.
      #
      # Example:
      #   # Without :default key
      #   class UserProfile
      #     check_authorizations :read  => Policies::FriendPolicy,
      #                          :write => Policies::OwnerPolicy
      #   end
      #
      #   # With :default key
      #   class UserProfile
      #     check_authorizations :read    => Policies::FriendPolicy,
      #                          :write   => Policies::OwnerPolicy,
      #                          :default => Policies::AdminPolicy
      #   end
      #
      #   # Without any key at all
      #   class UserProfile
      #     # this policy is the default one
      #     check_authorizations Policies::OwnerPolicy
      #   end
      #
      #  Once you stablish the authorizations policies on a subject, you can
      #  check if an actor is able to interact with it via the Actor#can? method
      #
      #  Example: current_user.can?(:read, profile)
      #
      #  It's recommended (but not mandatory) that a policy specified to the action 
      #  is inherting from Walruz::Policy
      #
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