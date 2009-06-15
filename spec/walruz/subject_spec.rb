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
        Beatle::JOHN.can_be?(:talk_with, Beatle::PAUL)
      end.should raise_error(Walruz::AuthorizationActionsNotDefined)
    end
    
  end
  
end