class Policies::AdminPolicy < Walruz::Policy
  
  def authorized?(user, _)
    raise NotImplementedError.new("You need to implement the policy")
  end
  
end