require 'rubygems'
require 'spec'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'walruz'
require File.dirname(__FILE__) + '/scenario'

Spec::Runner.configure do |config|
end
