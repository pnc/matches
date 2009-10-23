require File.dirname(__FILE__) + "/match_method"

# Defines all the necessary components to allow defining dynamic methods.
module MatchDef
  # Defines a new class method that allows you to define dynamic instance methods.
  # Takes a regular expression and a block, which are stored and called later.
  def matches(regexp, &block)
    
    # This evil voodoo scares the crud out of me.
    # It sneaks into the instance upon which we are called
    # and sets a class variable, so we can keep track of what
    # match methods have been defined.
    unless self.class_variables.include?(:@@match_methods)
      self.send(:class_variable_set, :@@match_methods, [])
    end
    
    # The above statement tweaks the scope, so when we refer to
    # @@match_methods here, what we're really doing is referring to
    # the above @@match_methods.
    self.class_eval do
      @@match_methods << MatchMethod.new( :matcher => regexp,
                                          :proc => block )
    end
    
    self.class_eval {
      
      unless method_defined? :method_missing
        def method_missing(meth, *args, &block); super; end
      end
      
      unless method_defined?(:match_method_missing)
        # Defines a +method_missing+ that is aware of the
        # dynamically-defined methods and will call them if appropriate.
        def match_method_missing(message, *args, &block)
          puts "Trying to find a method for #{message} in #{@@match_methods.inspect}"
          result = nil
          
          # Attempt to evaluate this using a MatchMethod
          matched = @@match_methods.find do |mm|
            if mm.matches?(message)
              
              # Cache the method onto the class
              self.class.send(:define_method, message, lambda { |*largs|
                return mm.match(self, message, *largs) 
              })
              
              # Call the actual method
              result = self.send(message, *args)
              
              true
            end
          end
          return matched ? result : old_method_missing(message, args, &block)
        end
      
        alias_method :old_method_missing, :method_missing
        alias_method :method_missing, :match_method_missing
      end
    }
  end
  
  # Allows you to delete all defined dynamic methods on a class.
  # This permits testing.
  def reset_match_methods
    @@match_methods = []
  end
end

# Squirt these into Class so they're available in new classes.
Class.class_eval { include MatchDef }