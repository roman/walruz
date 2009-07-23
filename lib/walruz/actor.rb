module Walruz
  
  #
  # This module provides the methods that enable an _Actor_ to check if it is able
  # to do an action on a _Subject_. It also provides methods to check on specific
  # Policies given the policy label. The methods mostly used by classes that include this module are:
  #
  # [+can?(action, subject)+] Returns a Boolean indicating if the actor is authorized to do an action on the subject.
  # [+authorize(action, subject)+] Returns Either nil if the actor is not authorized or a Hash with the parameters returned from the Policy if the actor is authorized.
  # [+authorze!(action, subject)+] Returns a Hash returned by the Policy if the actor is authorized or raises a +Walruz::NotAuthorized+ exception otherwise.
  # [+satisfies?(policy_label, subject)+] Returns true or false if the Policy is satisfied with the actor and subject given.
  #
  module Actor
    
    #
    # Allows an _actor_ to check if he can perform an _action_ on a given
    # _subject_. 
    #
    # @param [Symbol] The action as it is declared on the +check_authorizations+ method on the _subject_ class.
    # @param [Walruz::Subject] The _subject_ on which the _actor_ wants to execute the _action_.
    # @param [Boolean] (optional) A boolean indicating if you want to reset the cached result.
    # @return [Bool] A boolean indicating if the _actor_ is authorized to perform the _action_ (or not) on the _subject_.
    #
    # @example An invocation to perform a `:read` action on a `Post` subject.
    # 
    # === Note:
    # This method will check the authorization the first time, following invocations will return a cached
    # result unless the third parameter is specified.
    #
    def can?(*args)
      if args.size == 2
        (cached_values_for_can[args] ||= can_without_caching(*args))[0]
      elsif args.size == 3 
        if args.pop
          (cached_values_for_can[args] = can_without_caching(*args))[0]
        else
          (cached_values_for_can[args] ||= can_without_caching(*args))[0]
        end
      else
        raise ArgumentError.new("wrong number of arguments (%d for 2)" % args.size) 
      end
    end
    
    
    #
    # Allows an actor to check if he can do some action on a given
    # subject.
    #
    # Params: 
    #   - label: The label of the action
    #   - subject: The subject which the actor wants to interact with
    #
    # Returns:
    #   Returns a a Hash with parameters given from the policy.
    #
    def authorize(*args)
      if args.size == 2
        cached_values_for_can[args] ||= can_without_caching(*args)
        cached_values_for_can[args][0] ? cached_values_for_can[args][1] : nil
      elsif args.size == 3 
        if args.pop
          cached_values_for_can[args] = can_without_caching(*args)[1]
          cached_values_for_can[args][0] ? cached_values_for_can[args][1] : nil
        else
          cached_values_for_can[args] ||= can_without_caching(*args)[1]
          cached_values_for_can[args][0] ? cached_values_for_can[args][1] : nil
        end
      else
        raise ArgumentError.new("wrong number of arguments (%d for 2)" % args.size) 
      end
    end
    
    # :nodoc:
    def can_without_caching(label, subject)
      subject.can_be?(label, self)
    end
    
    # :nodoc:
    def cached_values_for_can
      @_cached_values_for_can ||= {}
    end
    
    #
    # Allows an actor to check if he can do some action on a given
    # subject.
    #
    # Params: 
    #   - label: The label of the action
    #   - subject: The subject which the actor wants to interact with
    #
    # Returns:
    #   Returns a a Hash with parameters given from the policy.
    #
    # Raises: 
    #   Walruz::NotAuthorized error if the actor can't execute the action on the subject
    #    
    def authorize!(label, subject)
      result = subject.can_be?(label, self)
      if result[0]
        cached_values_for_can[[label, subject]] = result
        result[1]
      else
        response_params = result[1]
        error_message = response_params[:error_message] || "You are not authorized to access this content"
        raise NotAuthorized.new(self, subject, label, error_message) 
      end
    end
    
    #
    # Allows an actor to check if he the given policy applies to him and the given subject.
    # 
    # Params:
    #   - policy: label of the Policy the actor wants to check
    #   - subject: The subject which the actor wants to interact with
    #
    # block |policy_hash|: 
    #   If the actor can access the subject, then the block will be executed;
    #   this will receive the policy hash as a parameter.
    #
    # Returns:
    #   It returns a boolean indicating that the actor is authorized to 
    #   access (or not) the subject with the given Policy.
    #
    def satisfies?(policy_label, subject, &block)
      policy_clz = Walruz.fetch_policy(policy_label)
      result = policy_clz.return_policy.new.safe_authorized?(self, subject)
      if result[0]
        block.call(result[1]) if block_given?
      end
      result[0]
    end
    
  end
end