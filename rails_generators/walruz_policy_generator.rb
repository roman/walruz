class WalruzPolicyGenerator < Rails::Generator::NamedBase
  
  def manifest
    record do |m|
      m.class_collisions "#{class_name}Policy"
      m.directory 'lib/walruz/policies'
      m.template 'policy.rb', File.join('lib/walruz/policies', class_path, "#{file_name}_policy.rb")
    end
  end
  
  
end