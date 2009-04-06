require 'rubygems'
require 'test/unit'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'deprecate'

class Test::Unit::TestCase
  VERSION = "1.0"
  
  include Deprecate
end
