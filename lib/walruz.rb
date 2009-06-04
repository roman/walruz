module Walruz

  class NotAuthorized < Exception
  end
  
  base_path = File.dirname(__FILE__)
  autoload :Actor,   base_path + '/walruz/actor'
  autoload :Subject, base_path + '/walruz/subject'
  autoload :Policy,  base_path + '/walruz/policy'
  autoload :Utils,   base_path + '/walruz/utils'
  
  def self.setup
    config = self.new
    yield config
  end
  
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