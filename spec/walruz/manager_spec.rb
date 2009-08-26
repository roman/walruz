require File.dirname(__FILE__) + "/../spec_helper"

describe Walruz::Manager do

  describe "#check_authorization" do 

    it "should invoke the policies associated to an action on a subject performed by an actor" do
      result = Walruz::Manager.check_action_authorization(Beatle::JOHN, :sing, Song::ALL_YOU_NEED_IS_LOVE)
      result[0].should be_true
    end

    describe "when executing validations on an invalid subject" do

      it "should raise an Walruz::AuthorizationActionsNotDefined error" do
        lambda do
          Walruz::Manager.check_action_authorization(Beatle::JOHN, :talk_with, Beatle::PAUL)
        end.should raise_error(Walruz::AuthorizationActionsNotDefined)
      end

    end

  end

  describe "::AuthorizationQuery" do

    describe "when excuting the authorize! method" do

      describe "and the actor is not authorized" do

        it "should raise a Walruz::NotAuthorized exception" do
          lambda do
            Walruz.authorize!(Beatle::RINGO, :sing, Song::YESTERDAY)
          end.should raise_error(Walruz::NotAuthorized)
        end

        it "should raise a Walruz::NotAuthorized exception with info about the actor, subject and action" do
          begin
            Walruz.authorize!(Beatle::RINGO, :sing, Song::YESTERDAY)
          rescue Walruz::NotAuthorized => e
            e.actor.should == Beatle::RINGO
            e.subject.should == Song::YESTERDAY
            e.action.should == :sing
          end
        
        end

      end

    end

  end


end
