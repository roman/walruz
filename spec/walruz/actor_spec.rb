require File.dirname(__FILE__) + '/../spec_helper'

describe 'Walruz::Actor' do
  
  it "should add an instance method `can?` to included classes" do
    Beatle::JOHN.should respond_to(:can?)
  end
  
end