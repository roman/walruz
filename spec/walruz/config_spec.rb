require File.dirname(__FILE__) + "/../spec_helper"

describe Walruz::Config do

  describe "#enable_will_paginate_extension" do
    
    it "should raise a RuntimeError if the will_paginate gem is not found" do
      pending("Can't do until I find out how to mock gem invocations")
      Kernel.should_receive(:gem).with("mislav-will_paginate").and_raise(Gem::LoadError)
      config = Walruz::Config.new
      lambda do
        config.enable_will_paginate_extension
      end.should raise_error(LoadError, "You ask to enable Walruz extensions on WillPaginate, but it was not found, Maybe you should require 'will_paginate' first")
    end

    it "should raise a RuntimeError if the :include_rails_extensions is given and rails is not required already" do
      pending("Can't do until I find out how to mock gem invocations")
      config = Walruz::Config.new
      lambda do
        config.enable_will_paginate_extension(:include_rails => true)
      end.should raise_error(LoadError, "You ask to enable Walruz extensions on ActiveRecord::Base, but it was not found. Maybe you should require 'active_record' first")

    end

  end

end
