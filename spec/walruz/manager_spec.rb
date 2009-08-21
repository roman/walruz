require File.dirname(__FILE__) + "/../spec_helper"

describe Walruz::Manager do

  describe "#check_authorization" do 

    it "should invoke the policies associated to an action on a subject performed by an actor" do
      result = Walruz::Manager.check_authorization(Beatle::JOHN, :sing, Song::ALL_YOU_NEED_IS_LOVE)
      result[0].should be_true
    end

    describe "when executing validations on an invalid subject" do

      it "should raise an Walruz::AuthorizationActionsNotDefined error" do
        lambda do
          Walruz::Manager.check_authorization(Beatle::JOHN, :talk_with, Beatle::PAUL)
        end.should raise_error(Walruz::AuthorizationActionsNotDefined)
      end

    end

  end


end
