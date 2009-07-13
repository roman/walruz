class Beatle
  include Walruz::Actor
  include Walruz::Subject
  
  attr_reader :name
  attr_accessor :songs
  attr_accessor :colaborations
  
  def initialize(name)
    @name = name
    @songs = []
    @colaborations = []
  end
  
  def sing_the_song(song)
    response = authorize!(:sing, song)
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
  
  def sing_with_john(song)
    authorize!(:sing_with_john, song)
    "Ok John, Let's Play '%s'" % song.name
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
  JOHN_GEORGE = self.new(Beatle::JOHN, Beatle::GEORGE)
end

class SubjectIsActorPolicy < Walruz::Policy
  
  def authorized?(actor, subject)
    actor == subject
  end
  
end

# class AuthorPolicy < Walruz::Policy
#   
#   def authorized?(beatle, song)
#     if song.author == beatle
#       [true, { :owner => beatle }]
#     else
#       false
#     end
#   end
#   
# end

AuthorPolicy = SubjectIsActorPolicy.for_subject(:author) do |authorized, params, actor, subject|
  params.merge!(:owner => actor) if authorized
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

class ColaboratingWithJohnPolicy < Walruz::Policy
  depends_on AuthorInColaborationPolicy
  
  def authorized?(beatle, song)
    params[:owner].authors.include?(Beatle::JOHN)
  end
  
end

class Song
  include Walruz::Subject
  extend Walruz::Utils

  check_authorizations :sing => any(AuthorPolicy, AuthorInColaborationPolicy),
                       :sell => all(AuthorPolicy, negate(AuthorInColaborationPolicy)),
                       :sing_with_john => ColaboratingWithJohnPolicy
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

