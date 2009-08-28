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
  
  class PolicyHalted < Exception 
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

end
