module Walruz
  #
  # This module provides pretty handy methods to do compositions of basic policies to create
  # more complex ones.
  #
  # === Using a policies file to manage complex policies
  #
  # It's always a good idea to keep the policy composition in one place, you may place a file in your 
  # project where you manage all the authorization policies, and then you use them on your models.
  #
  # Say for example you have a <tt>lib/policies.rb</tt> in your project where you manage the composition of policies,
  # and a <tt>lib/policies</tt> folder where you create your custom policies.
  #
  # The <tt>lib/policies.rb</tt> file could be something like this:
  # 
  #   module Policies
  #     include Walruz::Utils 
  #     
  #     # Requiring basic Walruz::Policy classes
  #     BASE = File.join(File.dirname(__FILE__), "policies") unless defined?(BASE)
  #     require File.join(BASE, "actor_is_admin")
  #     require File.join(BASE, "user_is_owner")
  #     require File.join(BASE, "user_is_friend")
  #   
  #     #####
  #     # User Policies
  #     #
  #     UserCreatePolicy  = ActorIsAdmin
  #     UserReadPolicy    = any(UserIsOwner, UserIsFriend, ActorIsAdmin)
  #     UserUpdatePolicy  = any(UserIsOwner, ActorIsAdmin)
  #     UserDestroyPolicy = ActorIsAdmin
  # 
  #   end
  # 
  # Using a policies file on your project, keeps all your authorization logic just in one place
  # that way, when you change the authorizations you just have to go to one place only.
  #
  module Utils
    
    module PolicyCompositionHelper # :nodoc: all
      
      #-- NOTE: Not using cattr_accessor to avoid dependencies with ActiveSupport
      
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
    
    #
    # Generates a new policy that merges together different policies by an <em>OR</em> association.
    # As soon as one of the policies succeed, the parameters of that policy will be returned.
    #
    # @param [Array<Walruz::Policy>] A set of policies that will be merged by an <em>OR</em> association.
    # @return [Walruz::Policy] A new policy class that will execute each policy until one of them succeeds.
    #
    # @example 
    #   UserReadPolicy = any(UserIsOwner, UserIsAdmin)
    #
    def any(*policies)
      clazz = Class.new(Walruz::Policy) do # :nodoc:
        extend PolicyCompositionHelper
        
        def authorized?(actor, subject) # :nodoc:
          result = nil
          self.class.policies.detect do |policy|
            result = policy.new.set_params(params).safe_authorized?(actor, subject)
            result[0]
          end
          result[0] ? result : result[0]
        end
      
      end
      clazz.policies = policies
      clazz
    end
    
    #
    # Generates a new policy that merges together different policies by an <em>AND</em> association.
    # This will execute every <em>policy</em> on the list, if all of them return true then the policy will
    # succeed. This process will merge the parameters of each policy, so you may be able to use the parameters 
    # of previous policies, and at the end it will return all the parameters from every policy.
    #
    # @param [Array<Walruz::Policy>] A set of policies that will be merged by an <em>AND</em> association.
    # @return [Walruz::Policy] A new policy class that will check true for each policy.
    #
    def all(*policies)
      clazz = Class.new(Walruz::Policy) do # :nodoc:
        extend PolicyCompositionHelper
        
        def authorized?(actor, subject) # :nodoc:
          acum = [true, self.params || {}]
          self.class.policies.each do |policy|
            break unless acum[0]
            result = policy.new.set_params(acum[1]).safe_authorized?(actor, subject)
            acum[0] &&= result[0]
            acum[1].merge!(result[1])
          end
          acum[0] ? acum : acum[0]
        end
        
        def self.policy_keyword # :nodoc:
          (self.policies.map { |p| p.policy_keyword.to_s[0..-2] }.join('_and_') + "?").to_sym
        end
        
      end
      clazz.policies = policies
      clazz
    end
    
    # 
    # Generates a new policy that negates the result of the given policy.
    # @param [Walruz::Policy] The policy which result is going to be negated.
    # @param [Walruz::Policy] A new policy that will negate the result of the given policy.
    #
    def negate(policy)
      clazz = Class.new(Walruz::Policy) do # :nodoc:
        extend PolicyCompositionHelper
        
        # :nodoc:
        def authorized?(actor, subject)
          result = self.class.policy.new.set_params(params).safe_authorized?(actor, subject)
          result[0] = !result[0]
          result
        end
        
        
        def self.policy_keyword # :nodoc:
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