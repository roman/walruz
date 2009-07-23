module Walruz

  class NotAuthorized < Exception
    
    attr_reader :actor
    attr_reader :subject
    attr_reader :action
    
    def initialize(actor, subject, action, error_message = nil)
      @actor   = actor
      @subject = subject
      @action  = action
      
      if error_message.nil?
        super
      else
        super(error_message)
      end
    end
    
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
  
  def self.fetch_policy(policy_label)
    policy_clz = Walruz.policies[policy_label]
    raise ActionNotFound.new(:policy_label, :label => policy_label) if policy_clz.nil?
    policy_clz
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

require File.dirname(__FILE__) + '/walruz/core_ext/array'
Array.send(:include, Walruz::CoreExt::Array)