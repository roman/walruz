require File.dirname(__FILE__) + '/../spec_helper'

describe Walruz::Utils do
  
  def check_actor_can_on_subject(label, actor, subject)
    lambda do
      actor.can!(label, subject)
    end.should_not raise_error(Walruz::NotAuthorized)
  end
  
  def check_actor_can_not_on_subject(label, actor, subject)
    lambda do
      actor.can!(label, subject)
    end.should raise_error(Walruz::NotAuthorized)
  end
  
  describe "when using combinators `orP`, `andP` or `notP`" do
    
    it "should work properly" do
      check_actor_can_not_on_subject(:sell, Beatle::JOHN, Song::A_DAY_IN_LIFE)
      check_actor_can_on_subject(:sell, Beatle::JOHN, Song::ALL_YOU_NEED_IS_LOVE)
    end
    
  end
  
  describe "when using andP" do

    it "should return as policy keyword, the name of the original policies keywords concatenated with `_and_`" do
      Beatle::JOHN.can?(:sell, Song::ALL_YOU_NEED_IS_LOVE) do |policy_params|
        policy_params[:"author_policy_and_not(author_in_colaboration_policy)?"].should be_true
      end
    end
    
  end
  
  describe "when using notP" do
    
    it "should return as policy keyword, the name of the original policy keyword with a `not()` around" do
      Beatle::JOHN.can?(:sell, Song::ALL_YOU_NEED_IS_LOVE) do |policy_params|
        policy_params[:"not(author_in_colaboration_policy)?"].should be_true
      end
    end
    
  end
  
end