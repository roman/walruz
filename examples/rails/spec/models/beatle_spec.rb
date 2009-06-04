require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Beatle do
  
  before(:all) do
    @john   = Beatle.create!(:name => 'John Lennon')
    @paul   = Beatle.create!(:name => 'Paul McCartney')
    @george = Beatle.create!(:name => 'George Harrison')
    @ringo  = Beatle.create!(:name => 'Ringo Starr')
    @john_paul = Colaboration.new
    @john_paul.beatles << @john
    @john_paul.beatles << @paul
    @john_paul.save!
    @a_day_in_life = Song.create!(:author => @john_paul, :name => 'A Day In Life')
    @all_you_need_is_love = Song.create!(:author => @john, :name => 'All You Need Is Love')
    @yesterday = Song.create!(:author => @paul, :name => 'Yesterday')
  end
  
  describe "when wants to sing a song" do
    
    it "should be able to do it when he is the author or a colaborator" do
      @john.sings(@a_day_in_life).should == "I'll need Paul McCartney to perform this properly"
    end
    
    it "should not be able to do it when he is not the author nor the colaborator" do
      lambda do
        @john.sings(@yesterday)
      end.should raise_error(Walruz::NotAuthorized)
    end
    
  end
  
  describe "when he wants to sell a song" do
    
    it "should be able to do so if he is the only author" do
      @john.sell(@all_you_need_is_love).should == "Who wants the rights of 'All You Need Is Love'?"
    end
    
    it "should not be able to do so if he is on a colaboration" do
      lambda do
        @john.sell(@a_day_in_life)
      end.should raise_error(Walruz::NotAuthorized)
    end
    
  end
  
end
