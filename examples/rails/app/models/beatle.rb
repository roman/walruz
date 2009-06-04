class Beatle < ActiveRecord::Base
  
  has_many :songs, :as => :author
  has_and_belongs_to_many :colaborations
  
  def sings(song)
    response = self.can?(:sing, song)
    if response[:is_colaboration?]
      colaboration = response[:colaboration]
      (other_beatles = colaboration.beatles.dup).delete(self)
      "I'll need %s to perform this properly" % other_beatles.join(', ')
    else
      'I can do this by myself!, Lets Rock \m/'
    end
  end
  
  def sell(song)
    self.can?(:sell, song)
    "Who wants the rights of '%s'?" % song.name
  end
  
  def to_s
    self.name
  end
  
end
