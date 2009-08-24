module Walruz 

  # The objective of this class is to start the invocation
  # of the authorization process, the methods of this class are used
  # internally by the actor and subject classes.
  #
  class Manager

    module AuthorizationQuery

      def can?(actor, action, subject)
        Walruz::Manager.check_action_authorization(actor, action, subject)[0]
      end

      def authorize!(actor, action, subject)
        result = Walruz::Manager.check_action_authorization(actor, action, subject)
        if result[0]
          result[1]
        else
          response_params = result[1]
          error_message   = response_params[:error_message] || "You are not authorized to access this content"
          raise NotAuthorized.new(self, subject, action, error_message)
        end
      end

      def authorize(actor, action, subject)
        result = Walruz::Manager.check_action_authorization(actor, action, subject)
        result[0] ? result[1] : nil
      end

      def satisfies?(actor, policy_label, subject)
        result = Walruz::Manager.check_policy_authorization(actor, policy_label, subject)
        result[0]
      end

      def satisfies(actor, policy_label, subject)
        result = Walruz::Manager.check_policy_authorization(actor, policy_label, subject)
        result[0] ? result[1] : nil
      end

    end


    #
    # core method used on all the actor methods:
    # can?
    # authorize!
    # authorize
    # :private:
    def self.check_action_authorization(actor, action, subject)
      check_action_authorization_is_declared_on_subject(subject, action)
      action = if subject.class._walruz_policies.key?(:default)
                subject.class._walruz_policies.key?(action) ? action : :default
              else
                if subject.class._walruz_policies.key?(action) 
                  action
                else 
                  raise ActionNotFound.new(:subject_action, :subject => subject, 
                                                            :action => action)
                end
              end
      
      begin
        result = subject.class._walruz_policies[action].
                              return_policy.
                              new.
                              safe_authorized?(actor, subject)
      rescue PolicyHalted => e
        result = [false, {:error_message => e.message }]
      end

      result
    end

    def self.check_policy_authorization(actor, policy_label, subject)
      policy_clz = Walruz.fetch_policy(policy_label)
      
      begin
        result = policy_clz.return_policy.new.safe_authorized?(actor, subject)
      rescue PolicyHalted => e
        result = [false, { :error_message => e.message }]
      end

      result 
    end

    private

    def self.check_action_authorization_is_declared_on_subject(subject, action) 
      if subject.class._walruz_policies.nil?
        message =<<-BEGIN
You need to invoke `check_authorizations :#{action} => Policies::SomePolicy` on the #{subject.class.name} class
        BEGIN
        raise AuthorizationActionsNotDefined.new(message)
      end
    end

  end
end
