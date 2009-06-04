require File.dirname(__FILE__) + '/../spec_helper'

describe Walruz::Subject do
  
  it "should add a can_be? method" do
    Song::A_DAY_IN_LIFE.should respond_to(:can_be?)
  end
  
  it "should add a class method called check_authorizations" do
    Song.should respond_to(:check_authorizations)
  end
  
  describe "when executing authorization validations" do
    
    it "should raise an Walruz::Unauthorized error when the actor is not authorized" do
      lambda do
        Beatle::RINGO.sing_the_song(Song::ALL_YOU_NEED_IS_LOVE)
      end.should raise_error(Walruz::NotAuthorized)
    end
    
  end
  
end