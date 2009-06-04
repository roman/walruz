module Walruz
  
  #
  # Actors have the role to use subjects, so they are the ones
  # who can or cannot do something with a given subject
  # 
  module Actor
    
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
    def can?(label, subject)
      subject.can_be?(label, self)
    end
    
  end
end