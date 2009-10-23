require File.dirname(__FILE__) + "/match_method"

module MatchDef
  def matches(regexp, &block)
    @@match_methods ||= []
    
    @@match_methods << MatchMethod.new( :matcher => regexp,
                                        :proc => block )
    self.class_eval {
      unless respond_to?(:match_method_missing)
        def match_method_missing(message, *args)
          # Attempt to evaluate this using a MetaMethod
          result = @@match_methods.find do |mm|
            if mm.matches?(message)
              return mm.match(self, message, args)
            end
          end
          return result if result
          return old_method_missing(message, args)
        end
      
        alias_method :old_method_missing, :method_missing
        alias_method :method_missing, :match_method_missing
      end
    }
  end
  
  def reset_meta_methods
    @@match_methods = []
  end
end

Class.class_eval { include MatchDef }