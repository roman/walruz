module Policies
  class ColaborationPolicy < Walruz::Policy
  
    def authorized?(author, song)
      case author
      when Colaboration
        song.author == author
      when Beatle
        if song.author.is_a?(Beatle)
          song.author == author
        else
          return false unless song.author.beatles.include?(author)
          [true, {
            :is_colaboration? => true,
            :colaboration => song.author
          }]
        end
      end
    end
  
  end
end