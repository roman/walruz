module Walruz

  class NotAuthorized < Exception
  end
  
  class AuthorizationActionsNotDefined < Exception
  end
  
  class ActionNotFound < Exception
    
    def initialize(subject, flag)
      super("%s class doesn't have an authorization action called :%s nor a :default policy" % [subject.class.name, flag])
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