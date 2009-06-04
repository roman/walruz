module Walruz
  module Actor
    
    def can?(label, subject)
      subject.can_be?(label, self)
    end
    
  end
end