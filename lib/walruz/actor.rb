module Walruz
  
  #
  # Actors have the role to use subjects, so they are the ones
  # who can or cannot do something with a given subject
  # 
  module Actor
    
    #
    # Allows an actor to check if he can do some action on a given
    # subject. It is normally used with a block that get's executed if the
    # actor can execute the given action on the subject.
    #
    # Params: 
    #   - label: The label of the action
    #   - subject: The subject which the actor wants to interact with
    #
    # block |policy_hash|: 
    #   If the actor can access the subject, then the block will be executed;
    #   this will receive the policy hash as a parameter.
    #
    # Returns:
    #   It returns a boolean indicating that the actor is authorized to 
    #   access (or not) the subject
    #
    def can?(label, subject, &block)
      result = subject.can_be?(label, self)
      if result[0]
        block.call(result[1]) if block_given?
      end
      result[0]
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
    #   It can return either a Boolean or an Array of the form [Boolean, Hash].
    #   When is an Array, the second parameter is a Hash with parameters given from
    #   the policy.
    #
    # Raises: 
    #   Walruz::NotAuthorized error if the actor can't interact with the subject
    #    
    def can!(label, subject)
      result = subject.can_be?(label, self)
      if result[0]
        result[1]
      else
        response_params = result[1]
        error_message = response_params[:error_message] || "You are not authorized to access this content"
        raise NotAuthorized.new(error_message) 
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
      policy_clz = Walruz.policies[policy_label]
      raise ActionNotFound.new(:policy_label, :label => policy_label) if policy_clz.nil?
      result = policy_clz.return_policy.new.safe_authorized?(self, subject)
      if result[0]
        block.call(result[1]) if block_given?
      end
      result[0]
    end
    
  end
end