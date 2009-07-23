require File.dirname(__FILE__) + '/../spec_helper'

describe 'Walruz::Actor' do
  
  it "should add an instance method `authorize` to included classes" do
    Beatle::JOHN.should respond_to(:authorize)
  end
  
  it "should add an instance method `authorize!` to included classes" do
    Beatle::JOHN.should respond_to(:authorize!)
  end
  
  it "should add an instance method `can?` to included classes" do
    Beatle::JOHN.should respond_to(:can?)
  end
  
  it "should add an instance method `satisfies?` to included classes" do
    Beatle::JOHN.should respond_to(:satisfies?)
  end
  
  
  describe "#authorize" do
    
    it "should return nil when the actor is not authorized" do
      Beatle::RINGO.authorize(:sing, Song::ALL_YOU_NEED_IS_LOVE).should be_nil
    end
    
    it "should return the policy parameters when the actor is authorized" do
      result = Beatle::JOHN.authorize(:sing, Song::ALL_YOU_NEED_IS_LOVE)
      result.should_not be_nil
      result.should be_kind_of(Hash)
      result[:owner].should == Beatle::JOHN
    end
    
  end
  
  describe "#authorize!" do
    
    it "should raise a Walruz::NotAuthorized error when the actor is not authorized" do
      lambda do
        Beatle::RINGO.sing_the_song(Song::ALL_YOU_NEED_IS_LOVE)
      end.should raise_error(Walruz::NotAuthorized)
    end
    
    it "should raise a Walruz::NotAuthorized error with the information of actor, subject and action when actor is not authorized" do
      begin
        Beatle::RINGO.sing_the_song(Song::ALL_YOU_NEED_IS_LOVE)
      rescue Walruz::NotAuthorized => e
        e.actor.should == Beatle::RINGO
        e.subject.should == Song::ALL_YOU_NEED_IS_LOVE
        e.action == :sing
      end
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
    
    it "should be invoked only the first time and then return a cached solution" do
      Song::YELLOW_SUBMARINE.should_receive(:can_be?).once.and_return([true, {}])
      Beatle::JOHN.can?(:sing, Song::YELLOW_SUBMARINE, true)
      Beatle::JOHN.can?(:sing, Song::YELLOW_SUBMARINE)
    end
    
    it "if a boolean third parameter is received it should not use the cached result" do
      Beatle::JOHN.stub!(:can_without_caching).and_return([true, {}])
      Beatle::JOHN.can?(:sing, Song::ALL_YOU_NEED_IS_LOVE).should be_true
      
      Beatle::JOHN.stub!(:can_without_caching).and_return([false, {}])
      Beatle::JOHN.can?(:sing, Song::ALL_YOU_NEED_IS_LOVE).should be_true
      Beatle::JOHN.can?(:sing, Song::ALL_YOU_NEED_IS_LOVE, true).should be_false
    end
    
    it "should receive at least 2 parameters" do
      lambda do
        Beatle::JOHN.can?(:sing)
      end.should raise_error(ArgumentError)
    end
    
    it "should receive at most 3 parameters" do
      lambda do
        Beatle::JOHN.can?(:sing, Song::ALL_YOU_NEED_IS_LOVE, true, false)
      end.should raise_error(ArgumentError)
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
        params[:in_colaboration?].should be_true
      end
      Beatle::GEORGE.satisfies?(:colaborating_with_john_policy, Song::TAXMAN, &proc_called)
    end
    
  end
  
end