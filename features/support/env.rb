require File.dirname(__FILE__) + "/../../lib/matches"

require 'spec/stubs/cucumber'

Before do
  # Look through all the classes, some of which will have been defined
  # in the scenarios. Reset their match methods if necessary.
  Module.constants.each do |constant|
    klass = Kernel.const_get(constant)
    if klass.kind_of?(Class)
      klass.reset_match_methods if klass.respond_to?(:reset_match_methods)
    end
  end
  
  OutputStorage.clear()
end