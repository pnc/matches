class MatchMethod
  attr_accessor :matcher, :proc
  
  # Allows properties to be specified in the constructor.
  # E.g.,
  #   MetaMethod.new(:matcher => /foo/)
  def initialize(args)
    args.each do |key, value|
      send("#{key}=", value)
    end
  end
  
  # Returns whether this MetaMethod is capable of matching the given
  # message.
  def matches?(message)
    !!(message.to_s =~ matcher)
  end
  
  # Calls the method's proc if the message matches.
  def match(instance, message, *args)
    groups = message.to_s.match(matcher)[1..-1]
    
    # Should curry here: instance.instance_eval( &proc.curry(groups + args) )
    # Or we could use instance_exec.
    # But these require 1.9. Darn. One day!
    
    full = (groups + args).flatten
    instance.instance_exec(*full, &proc)
  end
end

# SWEET HACK ZOMG. Mind has been blown.
# http://www.ruby-forum.com/topic/54096
# Mauricio Fernandez is a Ruby beast.
# This provides instance-exec-like functionality in Ruby 1.8.

if RUBY_VERSION.split('.')[1].to_i < 9
  class Object
    def instance_exec(*args, &block)
      mname = "__instance_exec_#{Thread.current.object_id.abs}"
      class << self; self end.class_eval{ define_method(mname, &block) }
      begin
        ret = send(mname, *args)
      ensure
        class << self; self end.class_eval{ undef_method(mname) } rescue nil
      end
      ret
    end
  end
end