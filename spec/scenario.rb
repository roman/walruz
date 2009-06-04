class Beatle
  include Walruz::Actor
  
  attr_reader :name
  attr_accessor :songs
  attr_accessor :colaborations
  
  def initialize(name)
    @name = name
    @songs = []
    @colaborations = []
  end
  
  def sing_the_song(song)
    response = can?(:sing, song)
    case response[:owner]
    when Colaboration
      authors = response[:owner].authors.dup
      authors.delete(self)
      authors.map! { |author| author.name }
      "I need %s to play this song properly" % authors.join(', ')
    when Beatle
      "I just need myself, Let's Rock! \\m/"
    end
  end


  JOHN   = self.new("John")
  PAUL   = self.new("Paul")
  RINGO  = self.new("Ringo")
  GEORGE = self.new("George")
end

class Colaboration
  
  attr_accessor :authors
  attr_accessor :songs
  
  def initialize(*authors)
    authors.each do |author|
      author.colaborations << self
    end
    @authors = authors
    @songs = []
  end
  
  JOHN_PAUL = self.new(Beatle::JOHN, Beatle::PAUL)
  JOHN_PAUL_GEORGE = self.new(Beatle::JOHN, Beatle::PAUL, Beatle::GEORGE)
  JOHN_GEORGE = self.new(Beatle::PAUL, Beatle::GEORGE)
end

class AuthorPolicy < Walruz::Policy
  
  def authorized?(beatle, song)
    if song.author == beatle
      [true, { :owner => beatle }]
    else
      false
    end
  end
  
end

class AuthorInColaborationPolicy < Walruz::Policy
  
  def authorized?(beatle, song)
    return false unless song.colaboration
    if song.colaboration.authors.include?(beatle)
      [true, { :owner => song.colaboration }]
    else
      false
    end
  end
  
end

class Song
  include Walruz::Subject
  extend Walruz::Utils

  check_authorizations :sing => orP(AuthorPolicy, AuthorInColaborationPolicy),
                       :sell => andP(AuthorPolicy, notP(AuthorInColaborationPolicy))
  
  attr_accessor :name
  attr_accessor :colaboration
  attr_accessor :author
  
  def initialize(name, owner)
    @name = name
    case owner
    when Colaboration
      @colaboration = owner
    when Beatle
      @author = owner
    end
    owner.songs << self
  end
  
  A_DAY_IN_LIFE        = self.new("A Day In Life", Colaboration::JOHN_PAUL)
  YELLOW_SUBMARINE     = self.new("Yellow Submarine", Colaboration::JOHN_PAUL)
  TAXMAN               = self.new("Taxman", Colaboration::JOHN_GEORGE)
  YESTERDAY            = self.new("Yesterday", Beatle::PAUL)
  ALL_YOU_NEED_IS_LOVE = self.new("All You Need Is Love", Beatle::JOHN)
  BLUE_JAY_WAY         = self.new("Blue Jay Way", Beatle::GEORGE)
end

