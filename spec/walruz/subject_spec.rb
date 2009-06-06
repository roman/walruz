require File.dirname(__FILE__) + '/../spec_helper'

describe Walruz::Subject do
  
  it "should add a can_be? method" do
    Song::A_DAY_IN_LIFE.should respond_to(:can_be?)
  end
  
  it "should add a class method called check_authorizations" do
    Song.should respond_to(:check_authorizations)
  end
  
  describe "when executing validations on an invalid subject" do
    
    it "should raise an Walruz::AuthorizationActionsNotDefined error" do
      lambda do
        Beatle::PAUL.can?(:talk_with, Beatle::JOHN)
      end.should raise_error(Walruz::AuthorizationActionsNotDefined)
    end
    
  end
  
  describe "when executing authorization validations" do
    
    it "should raise a Walruz::NotAuthorized error when the actor is not authorized" do
      lambda do
        Beatle::RINGO.sing_the_song(Song::ALL_YOU_NEED_IS_LOVE)
      end.should raise_error(Walruz::NotAuthorized)
    end
    
    it "should not raise a Walruz::NotAuthorized error when the actor is authorized" do
      lambda do
        Beatle::JOHN.sing_the_song(Song::ALL_YOU_NEED_IS_LOVE)
      end.should_not raise_error(Walruz::NotAuthorized)
    end
    
    it "should provide parameteres for the invokator correctly" do
      Beatle::JOHN.sing_the_song(Song::ALL_YOU_NEED_IS_LOVE).should == "I just need myself, Let's Rock! \\m/"
      Beatle::JOHN.sing_the_song(Song::YELLOW_SUBMARINE).should == "I need Paul to play this song properly"
    end
    
  end
  
end