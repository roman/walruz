module Policies
  class <%= class_name %>Policy < Walruz::Policy
    # depends_on OtherPolicy
    
    def authorized?(actor, subject)
      raise NotImplementedError.new("You need to implement policy")
    end
    
  end
end