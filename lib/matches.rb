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
    unless self.send(:class_variable_defined?, :@@match_methods)
      self.send(:class_variable_set, :@@match_methods, [])
      self.send(:class_variable_set, :@@cached_match_methods, [])
    end
    
    # More voodoo. These work the same way as above, except they can
    # be used while within a class_eval context below.
    
    append_to_methods = Proc.new do |method|
      current = self.send(:class_variable_get, :@@match_methods)
      self.send(:class_variable_set, :@@match_methods, current + [method])
    end
    
    @@available_methods = Proc.new do
      self.send(:class_variable_get, :@@match_methods)
    end
    
    @@append_to_cached_methods = Proc.new do |method|
      current = self.send(:class_variable_get, :@@cached_match_methods)
      self.send(:class_variable_set, :@@cached_match_methods, current + [method])
    end
    
    # Actually append this method as a dynamic method.
    self.class_eval do
      append_to_methods.call(MatchMethod.new( :matcher => regexp,
                                              :proc => block ))
    end
    
    self.class_eval {
      
      # Create a method_missing that simply calls super. This prevents
      # us from running recursively.
      unless method_defined? :method_missing
        def method_missing(meth, *args, &block); super; end
      end
      
      unless method_defined?(:match_method_missing)
        # Defines a +method_missing+ that is aware of the
        # dynamically-defined methods and will call them if appropriate.
        def match_method_missing(message, *args, &block)
          result = nil
          
          # Attempt to evaluate this using a MatchMethod
          matched = @@available_methods.call.find do |mm|
            if mm.matches?(message)
              
              # Cache the method onto the class
              self.class.send(:define_method, message, lambda { |*largs|
                return mm.match(self, message, *largs) 
              })
              
              # Store the name of the cached method in order to facilitate
              # introspection.
              @@append_to_cached_methods.call(message)
              
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
    self.send(:class_variable_set, :@@match_methods, [])
    
    if self.send(:class_variable_defined?, :@@cached_match_methods)
      puts "Cleaning out #{self.inspect}<br/>"
      self.send(:class_variable_get, :@@cached_match_methods).each do |method|
        puts "I think there's a #{method} on it<br/>"
        throw "Shit" if self.send(:methods).include?(method)
        self.send(:undef_method, method) if self.send(:method_defined?, method)
      end
    end
    
    self.send(:class_variable_set, :@@cached_match_methods, [])
  end
end

# Squirt these into Class so they're available in new classes.
Class.class_eval { include MatchDef }