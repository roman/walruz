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
    
    # @private
    def can_be?(action, actor)
      check_authorization_actions_are_setted(action)
      action = if self.class._walruz_policies.key?(:default)
                self.class._walruz_policies.key?(action) ? action : :default
              else
                if self.class._walruz_policies.key?(action) 
                  action
                else 
                  raise ActionNotFound.new(self, action)
                end
              end
      
      result = self.class._walruz_policies[action].
                          return_policy.
                          new.
                          safe_authorized?(actor, self)
      
      result
    end
    
    # @private
    def check_authorization_actions_are_setted(action)
      if self.class._walruz_policies.nil?
        message =<<BEGIN
You need to invoke `check_authorizations :#{action} => Policies::SomePolicy` on the #{self.class.name} class
BEGIN
        raise AuthorizationActionsNotDefined.new(message)
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