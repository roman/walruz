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

    describe "when executing the satisfies! method" do
      
      describe "and the actor and subject satisfy the policy" do

        it "should return the policy hash" do
          policy_params = Walruz.satisfies!(Beatle::RINGO, :subject_is_actor, Beatle::RINGO)
          policy_params.should_not be_nil
          policy_params[:subject_is_actor?].should be_true
        end

      end

      describe "and the actor and subject can't satisfy the policy" do
        
        it "should raise a Walruz::NotAuthorized exception" do
          lambda do
            Walruz.satisfies!(Beatle::RINGO, :subject_is_actor, Beatle::JOHN)
          end.should raise_error(Walruz::NotAuthorized)
        end

        it "should raise a Walruz::NotAuthorized exception with info about the actor, subject and access action" do
          begin
            Walruz.satisfies!(Beatle::RINGO, :subject_is_actor, Beatle::JOHN)
          rescue Walruz::NotAuthorized => e
            e.actor.should == Beatle::RINGO
            e.subject.should == Beatle::JOHN
            e.action.should == :access
          end
        end

      end

    end

  end


end
