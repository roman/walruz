module Walruz
  
  #
  # One of the cores of the framework, it's purpuse is to encapsulate
  # some authorization logic with a given actor and subject.
  # It's main method `authorized?(actor, subject)` verifies that 
  # an actor is actually authorized to manage the subject. 
  #
  class Policy
    extend Walruz::Utils
    
    attr_reader :params
    
    # @private
    def self.inherited(child)
      @policies ||= {}
      unless child.policy_label.nil?
        @policies[child.policy_label] = child
      end
    end
    
    #
    # See Walruz.policies
    #
    def self.policies
      @policies || {}
    end
    
    #
    # Returns a Proc with a curried actor, making it easier
    # to perform validations of a policy in an Array of subjects
    # Params:
    #   - actor: The actor who checks if it is authorized
    #
    # Returns: (subject -> [Bool, Hash])
    #
    # Example:
    #   subjects.filter(&PolicyXYZ.with_actor(some_user))
    #
    def self.with_actor(actor)
      policy_instance = self.new
      lambda do |subject|
        policy_instance.safe_authorized?(actor, subject)[0]
      end
    end
    
    #
    # Stablish other Policy dependencies, so that they are executed
    # before the current one, giving chances to receive the previous 
    # policies return parameters
    #
    # Example: 
    #   class FriendEditProfilePolicy
    #     depends_on FriendPolicy
    #     
    #     def authorized?(actor, subject)
    #       params[:friend_relationship].can_edit? # for friend metadata
    #     end
    #
    #   end
    #
    def self.depends_on(*other_policies)
      self.policy_dependencies = (other_policies << self)
    end
    
    # Utility for depends_on macro
    # @private
    def self.policy_dependencies=(dependencies)
      @_policy_dependencies = dependencies
    end
    
    # Utility for depends_on macro
    # @private
    def self.policy_dependencies
      @_policy_dependencies
    end
    
    # Utility for depends_on macro
    # @private
    def self.return_policy
      if policy_dependencies.nil?
        self
      else
        andP(*policy_dependencies)
      end
    end
    
    # Utility method (copied from ActiveSupport)
    # @private
    def self.underscore(camel_cased_word)
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
    # Params:
    #   - actor: The object who checks if it is authorized
    #   - subject: The object that is going to be accesed
    #
    # Returns: [Bool, Hash]
    #
    def authorized?(actor, subject)
      raise NotImplementedError.new("You need to implement policy")
    end
    
    #
    # Returns the identifier of the Policy that will be setted on the 
    # policy params hash once the authorization is executed. 
    # 
    # Returns:
    # By default it will return a symbol with the name of the Policy class in underscore (unless the policy label
    # was setted, in that case the policy label will be used) with an '?' appended
    #
    def self.policy_keyword
      if self.policy_label.nil?
        nil
      else
        :"#{self.policy_label}?"
      end
      
    end
    
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
      @policy_label = label
    end
    
    # @private
    def safe_authorized?(actor, subject)
      result = Array(authorized?(actor, subject))
      result[1] ||= {}
      result[1][self.class.policy_keyword] = result[0] unless self.class.policy_keyword.nil?
      result
    end
    
    # @private
    def set_params(params)
      @params = params
    end    
    
  end
end