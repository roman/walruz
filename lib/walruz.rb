module Walruz

  class NotAuthorized < Exception
  end
  
  class AuthorizationActionsNotDefined < Exception
  end
  
  class ActionNotFound < Exception
    
    def initialize(failure, params = {})
      case failure
      when :subject_action
        super("%s class doesn't have an authorization action called :%s nor a :default policy" % [params[:subject].class.name, params[:action]])
      when :policy_label
        super("There is no Policy with the label %s" % params[:label])
      end
    end
    
    def initialize(label)
      super("There is no Policy with the label #{label.inspect}")
    end
    
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
  
  def self.policies
    Walruz::Policy.policies
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