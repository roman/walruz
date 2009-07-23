require File.dirname(__FILE__) + '/../spec_helper'

describe Walruz do

  it "should have a policies method" do
    Walruz.should respond_to(:policies)
  end
  
  describe '#policies' do
    
    it "should return all the policies created that have a label" do
      Walruz.policies.should_not be_nil
      Walruz.policies[:author_policy].should be_nil
      Walruz.policies[:in_colaboration].should == AuthorInColaborationPolicy
      Walruz.policies[:colaborating_with_john_policy].should == ColaboratingWithJohnPolicy
    end
    
  end
  
  describe "#fetch_policy" do
    
    it "should grab the policy if this is registered" do
      Walruz.fetch_policy(:in_colaboration).should == AuthorInColaborationPolicy
    end
    
    it "should raise an Walruz::ActionNotFound exception if the policy is not registered" do
      lambda do
        Walruz.fetch_policy(:author_in_colaboration_policy)
      end.should raise_error(Walruz::ActionNotFound)
    end
    
  end

end