class WalruzGenerator < Rails::Generator::Base
  
  def manifest
    record do |m|
      m.directory 'config/initializers'
      m.file 'config/initializers/walruz_initializer.rb', 'walruz_initializer.rb'
      
      m.directory 'lib/walruz'
      m.directory 'lib/walruz/policies'
      m.file 'lib/walruz/policies.rb', 'policies.rb'
      m.file 'lib/walruz/policies/admin.rb', 'admin_policy_example.rb'
      
      m.directory 'public'
      m.file 'public/unathorized.html', 'unauthorized.html'
    end
  end
  
  protected
  
  def banner
    "Usage: #{$0} walruz"
  end
  
end