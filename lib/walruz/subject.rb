module Walruz
  
  #
  # This module provides the methods that enable a <em>subject</em> to register 
  # the diferent actions that can be performed to it, and associates the policies
  # that apply to each of these actions.
  # 
  # == Associating policies with actions on the <em>subject</em>.
  #
  # To associate policies and actions related to a <em>subject</em>, we use the <tt>check_authorizations</tt>
  # method, this will receive a Hash, where the keys are the name of the actions, and the values are the policies
  # associated to this actions.
  #
  # === Example:
  #   class Profile < ActiveRecord::Base
  #     include Walruz::Subject
  #     belongs_to :user
  #     check_authorizations :read   => ProfileReadPolicy,
  #                          :update => ProfileUpdatePolicy
  #   end
  #
  # Once the actions are registered on the <em>subject</em>, you can check if an <em>actor</em> can perform
  # an action on it, using the <tt>Walruz::Actor</tt> methods
  #
  module Subject
    
    def self.included(base) # :nodoc:
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
    
    def can_be?(action, actor) # :nodoc:
      check_authorization_actions_are_setted(action)
      action = if self.class._walruz_policies.key?(:default)
                self.class._walruz_policies.key?(action) ? action : :default
              else
                if self.class._walruz_policies.key?(action) 
                  action
                else 
                  raise ActionNotFound.new(:subject_action, :subject => self, 
                                                            :action => action)
                end
              end
      
      result = self.class._walruz_policies[action].
                          return_policy.
                          new.
                          safe_authorized?(actor, self)
      
      result
    end
    
    def check_authorization_actions_are_setted(action) # :nodoc:
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
      # policy, that will get executed if a specified flag doesn't exist.
      # You just have to pass the action :default, or the policy class only.
      #
      # Once you stablish the authorizations policies on a subject, you can
      # check if an actor is able to interact with it via the Walruz::Actor methods
      #
      # @param [Hash] Set of actions with associated policies
      # @return self
      #
      # @example
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
      # @example Invoking the actions from the actor
      #   current_user.can?(:read, profile)
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