require 'time'

# A module for allowing for deprecation of (primarily) testing code.  Useful for
# quick hacks or workarounds that should later be refactored away or code that will
# definitely change for whatever reason.
module Deprecate
  # Error class for deprecation
  class DeprecatedError < StandardError
  end
  
  # The main method for code deprecation.  Called with a variety of arguments for varying effect.
  # The first argument is always what you are deprecating (to be inserted into the deprecation message
  # later on for reference).
  #
  # === Examples
  #
  #     # Deprecate after a certain date
  #     deprecate "this feature", :after => "June 19, 2009" do
  #       assert "awesome"
  #     end
  # 
  #     # Deprecate if a proc's result is true
  #     deprecate "this other feature", :when => lambda { this_conditional == true } do
  #       assert "failure!"
  #     end
  # 
  #     # Deprecate at a certain version
  #     # Version is drawn from a VERSION constant in the current class, its parent class, or Kernel
  #     # You can set it in test_helper/spec_helper like: VERSION = YourLib::VERSION
  #     deprecate "that feature dude", :version => "1.0" do
  #       assert "this be deprecated"
  #     end
  # 
  #     # Deprecate if the version is greater than a number
  #     deprecate "this thing", :version => greater_than("2.0") do
  #       assert "wat"
  #     end
  #
  def deprecate(what, qualifier = {}, &block)
    deprecated = true
    @extra ||= ""
    
    if qualifier[:after]
      time = Time.parse(qualifier[:after])
      deprecated = (Time.now.utc > time.utc)
      @extra = " as of #{time.strftime('%D %T')}"
    elsif qualifier[:when]
      deprecated = !!qualifier[:when].call
    elsif qualifier[:version] != nil  # might be false
      if qualifier[:version].is_a?(String)
        deprecated = (qualifier[:version] == current_version)
        @extra = " as of version #{qualifier[:version]}"
      else
        deprecated = qualifier[:version]
      end
    end

    @extra = ""
    
    if deprecated
      raise DeprecatedError, (qualifier[:message] || "`#{what}` is now deprecated#{@extra}.")
    else
      self.instance_eval(&block)
    end    
  end

  # Check if a version is greater than another version.
  #
  # === Example
  #
  #     deprecate "this thing", :version => greater_than("1.0") do
  #       # do whatever here
  #     end
  #
  def greater_than(number)
    @extra = " as of version #{number}"
    current_version > number
  end

private  
  # Private method to grab the current version
  def current_version
    version = self.class.const_get("VERSION") rescue super.const_get("VERSION") rescue Kernel.const_get("VERSION") rescue ""
  end
end