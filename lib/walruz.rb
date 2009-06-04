module Walruz

  class NotAuthorized < Exception
  end
  
  base_path = File.dirname(__FILE__)
  autoload :Actor,   base_path + '/walruz/actor'   
  autoload :Subject, base_path + '/walruz/subject' 
  autoload :Policy,  base_path + '/walruz/policy'  
  autoload :Utils,   base_path + '/walruz/utils'   
end