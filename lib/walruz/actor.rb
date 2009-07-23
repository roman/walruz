module Walruz
  
  #
  # This module provides the methods that enable an _actor_ to check if it is able
  # to do an action on a _subject_. It also provides methods to check on specific
  # Policies given the policy label. The methods mostly used by classes that include this module are:
  #
  # [<b>+can?(action, subject)+</b>] Returns a Boolean indicating if the actor is authorized to do an action on the subject.
  # [<b>+authorize(action, subject)+</b>] Returns Either nil if the actor is not authorized or a Hash with the parameters returned from the Policy if the actor is authorized.
  # [<b>+authorize!(action, subject)+</b>] Returns a Hash returned by the Policy if the actor is authorized or raises a +Walruz::NotAuthorized+ exception otherwise.
  # [<b>+satisfies?(policy_label, subject)+</b>] Returns true or false if the Policy is satisfied with the actor and subject given.
  # [<b>+satisfies(policy_label, subject)+</b>] Returns Either nil if the actor and subject don't satisfy the policy or a Hash with the parameters returned from the Policy.
  #
  module Actor
    
    #
    # Allows an _actor_ to check if he can perform an _action_ on a given
    # _subject_. 
    # === Note:
    # This method will check the authorization the first time, following invocations will return a cached
    # result unless the third parameter is specified.
    #
    # @param [Symbol] The action as it is declared on the +check_authorizations+ method on the _subject_ class.
    # @param [Walruz::Subject] The _subject_ on which the _actor_ wants to execute the _action_.
    # @param [Boolean] (optional) A boolean indicating if you want to reset the cached result.
    # @return [Boolean] A boolean indicating if the _actor_ is authorized to perform the _action_ (or not) on the _subject_.
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
    # subject. The main difference between this method and the +can?+ method is that
    # this will return a Hash of values returned by the policies, in case the _actor_ is 
    # not authorized, it will return nil.
    # === Note:
    # This method will check the authorization the first time, following invocations will return a cached
    # result unless the third parameter is specified.
    #
    # @param [Symbol] The action as it is declared on the +check_authorizations+ method on the _subject_ class.
    # @param [Walruz::Subject] The _subject_ on which the _actor_ wants to execute the _action_.
    # @param [Boolean] (optional) A boolean indicating if you want to reset the cached result.
    # @return [Hash] Parameters returned from the _policy_.
    #
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
    
    def can_without_caching(label, subject)
      subject.can_be?(label, self)
    end
    
    def cached_values_for_can
      @_cached_values_for_can ||= {}
    end
    
    #
    # Allows an actor to check if he can do some action on a given
    # subject. This method will behave similarly to the +authorize+ method, the only difference is that
    # instead of returning nil when the _actor_ is not authorized, it will raise a +Walruz::NotAuthorized+ exception.
    #
    # @param [Symbol] The action as it is declared on the +check_authorizations+ method on the _subject_ class.
    # @param [Walruz::Subject] The _subject_ on which the _actor_ wants to execute the _action_.
    # @return [Hash] Parameters returned from the _policy_.
    #
    # @raise [Walruz::NotAuthorized]  error if the _actor_ is not authorized to perform the specified action on the _subject_.
    #
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
    # Allows an _actor_ to check if he satisfies the condition of a _policy_ with a given _subject_.
    # 
    # Params:
    # @param [Symbol] The label of the _policy_.
    # @param [Walruz::Subject] The _subject_.
    # @return [Boolean] saying if the _actor_ and the _subject_ satisify the _policy_.
    #
    def satisfies?(policy_label, subject)
      policy_clz = Walruz.fetch_policy(policy_label)
      result = policy_clz.return_policy.new.safe_authorized?(self, subject)
      result[0]
    end
    
    
    #
    # Allows an _actor_ to check if he satisfies the condition of a _policy_ with a given _subject_.
    # 
    # Params:
    # @param [Symbol] The label of the _policy_.
    # @param [Walruz::Subject] The _subject_.
    # @return [Hash] Hash with the parameters returned from the _policy_ if the _actor_ and the _subject_ satisfy the _policy_, nil otherwise.
    #
    def satisfies(policy_label, subject)
      policy_clz = Walruz.fetch_policy(policy_label)
      result = policy_clz.return_policy.new.safe_authorized?(self, subject)
      result[0] ? result[1] : nil
    end
    
    protected :can_without_caching, :cached_values_for_can
    
  end
end