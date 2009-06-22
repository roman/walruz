require File.dirname(__FILE__) + '/../spec_helper'

describe 'Walruz::Actor' do
  
  it "should add an instance method `can!` to included classes" do
    Beatle::JOHN.should respond_to(:can!)
  end
  
  it "should add an instance method `can?` to included classes" do
    Beatle::JOHN.should respond_to(:can?)
  end
  
  it "should add an instance method `satisfies?` to included classes" do
    Beatle::JOHN.should respond_to(:satisfies?)
  end
  
  
  describe "can!" do
    
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
  
  describe '#can?' do
    
    it "should execute a given block if the condition is true" do
      proc_called = lambda { raise "Is being called" }
      lambda do
        Beatle::JOHN.can?(:sing, Song::ALL_YOU_NEED_IS_LOVE, &proc_called)
      end.should raise_error
    end
    
    
    it "should execute a given block that receives a hash of return parameters of the policy" do
      proc_called = lambda do |params|  
        params.should_not be_nil
        params.should be_kind_of(Hash)
        params[:author_policy?].should be_true
      end
      Beatle::JOHN.can?(:sing, Song::ALL_YOU_NEED_IS_LOVE, &proc_called)
    end
    
  end
  
  describe '#satisfies?' do
    
    it "should work with the symbol representation of the policy" do
      Beatle::PAUL.satisfies?(:colaborating_with_john_policy, Song::TAXMAN).should be_false
    end
    
    it "should check only the specified policy" do
      Beatle::PAUL.satisfies?(:colaborating_with_john_policy, Song::TAXMAN).should be_false
    end
    
    it "should raise a Walruz::ActionNotFound error if the policy is not found" do
      lambda do
        Beatle::GEORGE.satisfies?(:unknown_policy, Song::TAXMAN)
      end.should raise_error(Walruz::ActionNotFound)
    end
    
    it "should execute the block if the condition is true" do
      proc_called = Proc.new { raise "Is being called" }
      lambda do
        Beatle::GEORGE.satisfies?(:colaborating_with_john_policy, Song::TAXMAN, &proc_called)
      end.should raise_error
    end
    
    it "should execute the block that receives a hash of return parameters of the policy" do
      proc_called = lambda do |params|  
        params.should_not be_nil
        params.should be_kind_of(Hash)
        params[:author_in_colaboration_policy?].should be_true
      end
      Beatle::GEORGE.satisfies?(:colaborating_with_john_policy, Song::TAXMAN, &proc_called)
    end
    
  end
  
end