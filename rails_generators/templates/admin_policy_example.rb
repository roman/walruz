class Policies::AdminPolicy < Walruz::Policy
  
  def authorized?(user, _)
    # user.is_admin?
  end
  
end