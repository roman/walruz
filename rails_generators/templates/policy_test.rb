# You need to 
# require 'walruz/policies'
# in your spec_helper.rb file


class Policies::<%= class_name %>Test < Test::Unit
  
  def setup
    @policy = Policies::<%= class_name %>.new
  end
  
  def test_return_true_with_valid_association_of_actor_and_subject
    # setup valid association btw actor and subject
    # assert !@policy.safe_authorized?(actor, subject)[0]
  end
  
  def test_return_false_with_invalid_association_of_actor_and_subject
    # setup invalid association btw actor and subject
    # assert @policy.safe_authorized?(actor, subject)[0]
  end
  
end