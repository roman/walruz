module Policies
  class AuthorPolicy < Walruz::Policy
  
    def authorized?(author, song)
      song.author == author
    end
  
  end
end