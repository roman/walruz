module Walruz

  class NotAuthorized < Exception
  end
  
  class FlagNotFound < Exception
    
    def initialize(subject, flag)
      super("%s class doesn't have an authorization flag called %s nor a default policy", subject.name, flag)
    end
    
  end
  
  base_path = File.dirname(__FILE__)
  autoload :Actor,   base_path + '/walruz/actor'
  autoload :Subject, base_path + '/walruz/subject'
  autoload :Policy,  base_path + '/walruz/policy'
  autoload :Utils,   base_path + '/walruz/utils'
  
  def self.setup
    config = Config.new
    yield config
  end
  
  class Config
    
    def actors=(actors)
      Array(actors).each do |actor|
        actor.send(:include, Actor)
      end
    end

    def subjects=(subjects)
      Array(subjects).each do |subject|
        subject.send(:include, Subject)
      end
    end
    
  end
  

end