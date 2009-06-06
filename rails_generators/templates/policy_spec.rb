require File.dirname(__FILE__) + '/../spec_helper'
# You need to 
# require 'walruz/policies'
# in your spec_helper.rb file

describe Policies::<%= class_name %>Policy do
  
  before(:each) do
    @policy = Policies::<%= class_name %>Policy.new
  end
  
  describe "with valid actor and subject" do
    
    before(:each) do
      # setup valid relationship between actor and subject
    end
    
    it "should return true" do
      pending
      # @policy.safe_authorized?(@actor, @subject).should be_true
    end
    
  end
  
  describe "with invalid actor and subject" do
    
    before(:each) do
      # setup invalid relationship between actor and subject
    end
    
    it "should return false" do
      pending
      # @policy.safe_authorized?(@actor, @subject).should be_false
    end
    
  end
  
end