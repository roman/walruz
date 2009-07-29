module Walruz
  
  #
  # This module provides the methods that enable an <em>actor</em> to check if it is able
  # to do an action on a <em>subject</em>. It also provides methods to check on specific
  # Policies given the policy label. The methods mostly used by classes that include this module are:
  #
  # [<b><tt>can?(action, subject)</tt></b>] Returns a Boolean indicating if the actor is authorized to do an action on the subject.
  # [<b><tt>authorize(action, subject)</tt></b>] Returns Either nil if the actor is not authorized or a Hash with the parameters returned from the Policy if the actor is authorized.
  # [<b><tt>authorize!(action, subject)</tt></b>] Returns a Hash returned by the Policy if the actor is authorized or raises a <tt>Walruz::NotAuthorized</tt> exception otherwise.
  # [<b><tt>satisfies?(policy_label, subject)</tt></b>] Returns true or false if the Policy is satisfied with the actor and subject given.
  # [<b><tt>satisfies(policy_label, subject)</tt></b>] Returns Either nil if the actor and subject don't satisfy the policy or a Hash with the parameters returned from the Policy.
  #
  module Actor
    
    # @overload can?(action, subject)
    #   Allows an <em>actor</em> to check if he can perform an <em>action</em> on a given <em>subject</em>.
    #   === Note:
    #   This method will check the authorization the first time, following invocations will return a cached
    #   result unless the third parameter is specified.
    # 
    #   @param [Symbol] The action as it is declared on the <tt>check_authorizations</tt> method on the <em>subject</em> class.
    #   @param [Walruz::Subject] The <em>subject</em> on which the <em>actor</em> wants to execute the <em>action</em>.
    #   @param [Boolean] (optional) A boolean indicating if you want to reset the cached result.
    #   @return [Boolean] A boolean indicating if the <em>actor</em> is authorized to perform the <em>action</em> (or not) on the <em>subject</em>.
    #
    # @overload can?(action, subject, reload)
    #   Allows an <em>actor</em> to check if he can perform an <em>action</em> on a given <em>subject</em>.
    # 
    #   @param [Symbol] The action as it is declared on the <tt>check_authorizations</tt> method on the <em>subject</em> class.
    #   @param [Walruz::Subject] The <em>subject</em> on which the <em>actor</em> wants to execute the <em>action</em>.
    #   @param [Boolean] A boolean indicating if you want to reset the cached result.
    #   @return [Boolean] A boolean indicating if the <em>actor</em> is authorized to perform the <em>action</em> (or not) on the <em>subject</em>.
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
    
    
    # @overload authorize(action, subject)
    #   Allows an actor to check if he can do some action on a given
    #   subject. The main difference between this method and the <tt>can?</tt> method is that
    #   this will return a Hash of values returned by the policies, in case the <em>actor</em> is 
    #   not authorized, it will return nil.
    #   === Note:
    #   This method will check the authorization the first time, following invocations will return a cached
    #   result unless the third parameter is specified.
    # 
    #   @param [Symbol] The action as it is declared on the <tt>check_authorizations</tt> method on the <em>subject</em> class.
    #   @param [Walruz::Subject] The <em>subject</em> on which the <em>actor</em> wants to execute the <em>action</em>.
    #   @return [Hash] Parameters returned from the <em>policy</em>.
    #
    # @overload authorize(action, subject, reload)
    #   Allows an actor to check if he can do some action on a given
    #   subject. The main difference between this method and the <tt>can?</tt> method is that
    #   this will return a Hash of values returned by the policies, in case the <em>actor</em> is 
    #   not authorized, it will return nil.
    # 
    #   @param [Symbol] The action as it is declared on the <tt>check_authorizations</tt> method on the <em>subject</em> class.
    #   @param [Walruz::Subject] The <em>subject</em> on which the <em>actor</em> wants to execute the <em>action</em>.
    #   @param [Boolean] A boolean indicating if you want to reset the cached result.
    #   @return [Hash] Parameters returned from the <em>policy</em>.
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
    # subject. This method will behave similarly to the <tt>authorize</tt> method, the only difference is that
    # instead of returning nil when the _actor_ is not authorized, it will raise a <tt>Walruz::NotAuthorized</tt> exception.
    #
    # @param [Symbol] The action as it is declared on the <tt>check_authorizations</tt> method on the <em>subject</em> class.
    # @param [Walruz::Subject] The <em>subject</em> on which the <em>actor</em> wants to execute the <em>action</em>.
    # @return [Hash] Parameters returned from the <em>policy</em>.
    #
    # @raise [Walruz::NotAuthorized]  error if the <em>actor</em> is not authorized to perform the specified action on the <em>subject</em>.
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
    # Allows an <em>actor</em> to check if he satisfies the condition of a <em>policy</em> with a given <em>subject</em>.
    # 
    # Params:
    # @param [Symbol] The label of the <em>policy</em>.
    # @param [Walruz::Subject] The <em>subject</em>.
    # @return [Boolean] saying if the <em>actor</em> and the <em>subject</em> satisify the <em>policy</em>.
    #
    def satisfies?(policy_label, subject)
      policy_clz = Walruz.fetch_policy(policy_label)
      result = policy_clz.return_policy.new.safe_authorized?(self, subject)
      result[0]
    end
    
    
    #
    # Allows an <em>actor</em> to check if he satisfies the condition of a <em>policy</em> with a given <em>subject</em>.
    # 
    # Params:
    # @param [Symbol] The label of the <em>policy</em>.
    # @param [Walruz::Subject] The <em>subject</em>.
    # @return [Hash] Hash with the parameters returned from the <em>policy</em> if the <em>actor</em> and the <em>subject</em> satisfy the <em>policy</em>, nil otherwise.
    #
    def satisfies(policy_label, subject)
      policy_clz = Walruz.fetch_policy(policy_label)
      result = policy_clz.return_policy.new.safe_authorized?(self, subject)
      result[0] ? result[1] : nil
    end
    
    
    protected :can_without_caching, :cached_values_for_can
    
  end
end