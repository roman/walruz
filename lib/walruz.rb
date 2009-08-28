module Walruz

  base_path = File.dirname(__FILE__)
  require base_path + '/walruz/errors'
  autoload :Memoization, base_path + '/walruz/core_ext/memoization'
  autoload :Manager, base_path + '/walruz/manager'
  autoload :Actor,   base_path + '/walruz/actor'
  autoload :Subject, base_path + '/walruz/subject'
  autoload :Policy,  base_path + '/walruz/policy'
  autoload :Utils,   base_path + '/walruz/utils'
  autoload :Config,  base_path + '/walruz/config'
  

  def self.version
    require "yaml"
    version = YAML.load_file(File.dirname(__FILE__) + "/../VERSION.yml") 
    "%s.%s.%s" % [version[:major], version[:minor], version[:patch]]
  end

  def self.setup
    config = Config.new
    yield config
  end
  
  # Holds all the policies declared on the system
  # @return [Hash<Symbol, Walruz::Policy>] A hash of policies, each identified by it's policy label
  # @todo Make this thread-safe
  def self.policies
    Walruz::Policy.policies
  end
  
  # Returns a Walruz::Policy Class represented by the specified label 
  #
  # @param [Symbol] policy_label The label that identifies a policy
  # @return [Walruz::Policy] A Policy class.
  # @raise [Walruz::ActionNotFound] if the policy label is not recognized.
  # @example Fetching a policy with label :actor_is_admin
  #   Walruz.fetch_policy(:actor_is_admin) # => ActorIsAdmin
  #
  def self.fetch_policy(policy_label)
    policy_clz = Walruz.policies[policy_label]
    raise ActionNotFound.new(:policy_label, :label => policy_label) if policy_clz.nil?
    policy_clz
  end
  
  Config.add_authorization_query_methods_to(self) 
end
