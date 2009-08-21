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
    include Walruz::Manager::AuthorizationQuery
    include Walruz::Memoization

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
    def can?(action, subject)
      super(self, action, subject)
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
    #   @param [Symbol] A symbol with the value ":reload" indicating that you want to reset the cached result.
    #   @return [Hash] Parameters returned from the <em>policy</em>.
    def authorize(action, subject)
      super(self, action, subject)
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
      super(self, label, subject)
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
      super(self, policy_label, subject)
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
      super(self, policy_label, subject)
    end
    
    walruz_memoize :can?, :authorize, :satisfies?, :satisfies 
    
  end
end
