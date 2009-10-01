require File.dirname(__FILE__) + "/../../spec_helper"
require "will_paginate"

describe Walruz::More::Pagination do 
  
  before(:each) do
    @songs = [
      Song::A_DAY_IN_LIFE,
      Song::YELLOW_SUBMARINE,
      Song::TAXMAN,
      Song::YESTERDAY,
      Song::ALL_YOU_NEED_IS_LOVE,
      Song::BLUE_JAY_WAY,
      Song::ALL_YOU_NEED_IS_LOVE,
      Song::YESTERDAY,
      Song::TAXMAN,
      Song::YELLOW_SUBMARINE,
      Song::A_DAY_IN_LIFE,
      Song::BLUE_JAY_WAY
    ]
    @songs.extend(Walruz::More::Pagination)
  end

  it "should provide a #authorized_paginate method" do
    @songs.should respond_to(:authorized_paginate)
  end

  describe "#authorized_paginate" do
    
    it "should return a page of authorized elements" do
      result = @songs.authorized_paginate(Beatle::JOHN, :sing, :page => 1, :per_page => 5)
      result.should == [
        Song::A_DAY_IN_LIFE,
        Song::YELLOW_SUBMARINE,
        Song::TAXMAN,
        Song::ALL_YOU_NEED_IS_LOVE,
        Song::ALL_YOU_NEED_IS_LOVE
      ]

      result = @songs.authorized_paginate(Beatle::PAUL, :sing, :page => 1, :per_page => 5)
      result.should == [
        Song::A_DAY_IN_LIFE,
        Song::YELLOW_SUBMARINE,
        Song::YESTERDAY,
        Song::YESTERDAY,
        Song::YELLOW_SUBMARINE
      ]

      result = @songs.authorized_paginate(Beatle::GEORGE, :sell, :page => 1, :per_page => 5) 
      result.should == [
        Song::BLUE_JAY_WAY,
        Song::BLUE_JAY_WAY
      ]
    end

    it "should keep the data of the next page and it's offset" do
      result = @songs.authorized_paginate(Beatle::JOHN, :sing, :page => 1, :per_page => 5)
      result.current_page.should == 2
      result.walruz_offset.should == 2
      result.next_page.should == 2

      result = @songs.authorized_paginate(Beatle::GEORGE, :sell, :page => 1, :per_page => 5) 
      result.current_page.should == 3
      result.walruz_offset.should be_nil
      result.next_page.should be_nil
    end

    it "should return the following page of authorized data with the data given on the previous result" do
      result = @songs.authorized_paginate(Beatle::JOHN, :sing, :page => 1, :per_page => 5)
      result = @songs.authorized_paginate(Beatle::JOHN, :sing, :page => result.next_page, :per_page => 5, :offset => result.walruz_offset)
      result.should == [
        Song::TAXMAN,
        Song::YELLOW_SUBMARINE,
        Song::A_DAY_IN_LIFE
      ] 
      result.next_page.should be_nil
      
      result = @songs.authorized_paginate(Beatle::PAUL, :sing, :page => 1, :per_page => 5)
      result = @songs.authorized_paginate(Beatle::JOHN, :sing, :page => result.next_page, :per_page => 5, :offset => result.walruz_offset)
      result.should == [
        Song::A_DAY_IN_LIFE
      ]
    end

    it "should return an empty set for unauthorized elements" do
      result = @songs.authorized_paginate(Beatle::RINGO, :sing, :page => 1, :per_page => 5) 
      result.should be_empty
      result.current_page.should == 3
    end
  
    it "should filter collections with just a page of autorized items, and work properly for the next page" do
      songs = [Song::ALL_YOU_NEED_IS_LOVE] * 4

      result = songs.authorized_paginate(Beatle::JOHN, :sing, :page => 1, :per_page => 4)
      result.should have(4).songs
      result.next_page.should == 1
      result.walruz_offset.should == 4

      result = songs.authorized_paginate(Beatle::JOHN, :sing, :page => result.next_page, :per_page => 4, :offset => result.walruz_offset)
      result.should be_empty
      result.next_page.should be_nil
      result.walruz_offset.should be_nil
    end

    it "should not fail when the offset is greater than the items per page parameter" do
      lambda do
        @songs.authorized_paginate(Beatle::RINGO, :sing, :page => 1, :per_page => 5, :offset => 6)
      end.should_not raise_error
    end

    it "should work with an offset specified as an string" do
      lambda do
        @songs.authorized_paginate(Beatle::RINGO, :sing, :page => 1, :per_page => 5, :offset => '6')
      end.should_not raise_error
    end

  end

end
