require File.dirname(__FILE__) + '/../spec_helper'

describe Walruz::Policy do
  
  it "should provide the with_actor utility" do
    AuthorPolicy.should respond_to(:with_actor)
  end
  
  it "should generate an indicator that the policy was executed after authorization queries" do
    policy = Beatle::PAUL.can?(:sing, Song::YESTERDAY)
    policy[:author_policy?].should be_true
  end
  
  describe "when using the #with_actor method" do
    
    before(:each) do
      @songs = [Song::A_DAY_IN_LIFE, Song::YELLOW_SUBMARINE, Song::TAXMAN,
                Song::YESTERDAY, Song::ALL_YOU_NEED_IS_LOVE, Song::BLUE_JAY_WAY]
    end
    
    it "should work properly" do
      george_authorship_songs = @songs.select(&AuthorPolicy.with_actor(Beatle::GEORGE))
      george_authorship_songs.should have(1).song
      george_authorship_songs.should == [Song::BLUE_JAY_WAY]
      
      
      john_and_paul_songs = @songs.select(&AuthorInColaborationPolicy.with_actor(Beatle::JOHN))
      john_and_paul_songs.should have(2).songs
      john_and_paul_songs.should == [Song::A_DAY_IN_LIFE, Song::YELLOW_SUBMARINE]
    end
    
  end
  
  describe "when using dependence_on macro" do
    
    it "should work properly" do
      lambda do
        Beatle::PAUL.sing_with_john(Song::YESTERDAY)
      end.should raise_error(Walruz::NotAuthorized)
      
      Beatle::PAUL.sing_with_john(Song::A_DAY_IN_LIFE).should == "Ok John, Let's Play 'A Day In Life'"
    end
  
  end
  
end