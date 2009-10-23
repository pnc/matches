require File.dirname(__FILE__) + "/meta_method"

module MetaDef
  def meta_def(regexp, &block)
    @@meta_methods ||= []
    
    @@meta_methods << MetaMethod.new( :matcher => regexp,
                                      :proc => block )
    self.class_eval {
      unless respond_to?(:meta_method_missing)
        def meta_method_missing(message, *args)
          # Attempt to evaluate this using a MetaMethod
          result = @@meta_methods.find do |mm|
            if mm.matches?(message)
              return mm.match(self, message, args)
            end
          end
          return result if result
          return old_method_missing(message, args)
        end
      
        alias_method :old_method_missing, :method_missing
        alias_method :method_missing, :meta_method_missing
      end
    }
  end
  
  def reset_meta_methods
    @@meta_methods = []
  end
end

Class.class_eval { include MetaDef }