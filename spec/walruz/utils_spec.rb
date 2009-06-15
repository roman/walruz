require File.dirname(__FILE__) + '/../spec_helper'

describe Walruz::Utils do
  
  describe "when using combinators `orP`, `andP` or `notP`" do
    
    it "should work properly" do
      check_actor_can_not_on_subject(:sell, Beatle::JOHN, Song::A_DAY_IN_LIFE)
      check_actor_can_on_subject(:sell, Beatle::JOHN, Song::ALL_YOU_NEED_IS_LOVE)
    end
    
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
    
  end
  
end