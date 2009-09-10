module Walruz
  
  #
  # One of the cores of the framework, its purpose is to encapsulate an authorization logic 
  # with a given actor and subject. It's main method <tt>authorized?(actor, subject)</tt> 
  # verifies that an actor is authorized to manage the subject.
  #
  class Policy
    extend Walruz::Utils
    
    
    def self.inherited(child) # :nodoc:
      @policies ||= {}
      unless child.policy_label.nil?
        @policies[child.policy_label] = child
      end
    end

    def halt(msg="You are not authorized")
      raise PolicyHalted.new(msg)
    end

    
    # @see Walruz.policies
    def self.policies
      @policies || {}
    end
    
    #
    # Creates a new policy class based on an existing one, you may use this method
    # when you want to reuse a Policy class for a subject's association.
    # 
    # @param [Symbol] Name of the association that will be the subject of the policy.
    # @return [Walruz::Policy] New generated policy that will pass the association as the subject of the original <em>policy</em>.
    # 
    # @see http://github.com/noomii/walruz See the "Policy Combinators" section on the README for more info and examples.
    #
    def self.for_subject(key, &block)
      
      clazz = Class.new(Walruz::Policy) do # :nodoc:
        extend Walruz::Utils::PolicyCompositionHelper
        
        def authorized?(actor, subject) # :nodoc:
          params = self.class.params
          new_subject = subject.send(params[:key])
          result = self.class.policy.new.safe_authorized?(actor, new_subject)
          params[:callback].call(result[0], result[1], actor, subject) if params[:callback]
          result
        end
        
      end
      clazz.policy = self
      clazz.set_params(:key => key, :callback => block)
      clazz
    end
    
    #
    # Returns a Proc with a curried actor, making it easier to perform validations of a policy 
    # in an Array of subjects.
    #
    # @param [Walruz::Actor] The actor who checks if he is authorized.
    # @return [Proc] A proc that receives as a parameter subject and returns what the <tt>authorized?</tt> 
    #                method returns.
    # 
    # @example
    #   subjects.select(&PolicyXYZ.with_actor(some_user))
    #
    # @see Walruz::CoreExt::Array#only_authorized_for
    def self.with_actor(actor)
      policy_instance = self.new
      lambda do |subject|
        policy_instance.safe_authorized?(actor, subject)[0]
      end
    end
    
    #
    # Stablish other Policy dependencies, so that they are executed
    # before the current one, giving chances to receive the previous 
    # policies return parameters.
    # 
    # @param [Array<Walruz::Policies>] Policies in wich this policy depends on.
    # @return self
    #
    # @example 
    #   class FriendEditProfilePolicy
    #     depends_on FriendPolicy
    #     
    #     def authorized?(actor, subject)
    #       # The FriendPolicy returns a hash with a key of :friend_relationship
    #       # this will be available via the params method.
    #       params[:friend_relationship].can_edit? # for friend metadata
    #     end
    #
    #   end
    #
    def self.depends_on(*other_policies)
      self.policy_dependencies = (other_policies << self)
    end
    
    # Utility for depends_on macro
    def self.policy_dependencies=(dependencies) # :nodoc:
      @_policy_dependencies = dependencies
    end
    
    # Utility for depends_on macro
    def self.policy_dependencies # :nodoc:
      @_policy_dependencies
    end
    
    # Utility for depends_on macro
    def self.return_policy # :nodoc:
      if policy_dependencies.nil?
        self
      else
        all(*policy_dependencies)
      end
    end
    
    # Utility method (from ActiveSupport)
    def self.underscore(camel_cased_word) # :nodoc:
      if camel_cased_word.empty?
        camel_cased_word
      else
        camel_cased_word.to_s.split('::').last.
                gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
                gsub(/([a-z\d])([A-Z])/,'\1_\2').
                tr("-", "_").
                downcase
      end
    end
    
    
    #
    # Verifies if the actor is authorized to interact with the subject
    # @param [Walruz::Actor] The object who checks if it is authorized
    # @param [Walruz::Subject] The object that is going to be accesed
    # @return It may return a Boolean, or an Array with the first position being a boolean and the second
    #          being a Hash of parameters returned from the policy.
    #
    #
    #
    def authorized?(actor, subject)
      raise NotImplementedError.new("You need to implement policy")
    end
    
    #
    # Returns the identifier of the Policy that will be setted on the 
    # policy params hash once the authorization is executed. 
    # 
    # @return [Symbol] By default it will return a symbol with the name of the Policy class in underscore (unless the policy label
    #         was setted, in that case the policy label will be used) with an '?' appended.
    #
    def self.policy_keyword
      if self.policy_label.nil?
        nil
      else
        :"#{self.policy_label}?"
      end
      
    end
    
    #
    # Returns the label assigned to the policy
    #
    def self.policy_label
      @policy_label ||= (self.name.empty? ? nil : :"#{self.underscore(self.name)}")
    end
    
    #
    # Sets the identifier of the Policy for using on the `satisfies?` method
    #
    # Parameters:
    #   - label: Symbol that represents the policy
    # 
    def self.set_policy_label(label)
      policy = Walruz.policies[self.policy_label]
      if policy.nil?
        Walruz.policies[label] = self
      else
        Walruz.policies.delete(self.policy_label)
        Walruz.policies[label] = policy
      end
      @policy_label = label
    end
    
    def safe_authorized?(actor, subject) # :nodoc:
      result = Array(authorized?(actor, subject))
      result[1] ||= {}
      result[1][self.class.policy_keyword] = result[0] unless self.class.policy_keyword.nil?
      result
    end
    
    def set_params(params) # :nodoc:
      @params = params
      self
    end
    
    def params
      @params ||= {}
    end

    
  end
end
