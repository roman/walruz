require File.dirname(__FILE__) + '/../spec_helper'

describe Walruz do

  it "should have a policies method" do
    Walruz.should respond_to(:policies)
  end
  
  describe '#policies' do
    
    it "should return all the policies created that have a label" do
      Walruz.policies.should_not be_nil
      Walruz.policies[:author_policy].should be_nil
      Walruz.policies[:author_in_colaboration_policy].should == AuthorInColaborationPolicy
      Walruz.policies[:colaborating_with_john_policy].should == ColaboratingWithJohnPolicy
    end
    
  end

end