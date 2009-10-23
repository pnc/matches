# A MatchMethod a method that has a regular expression rather than a name.
# It simply stores a proc and the regular expression. To use:
# 
#     mm = new MatchMethod(:matcher => /foo(w+)/, :proc => Proc.new {puts inspect})
#     fancy_object = Object.new
#     mm.match(fancy_object, :foobar)
#     => <Object:0x1018746f8> 
#
class MatchMethod
  attr_accessor :matcher, :proc
  
  # Allows properties to be specified in the constructor.
  # E.g.,
  #   MatchMethod.new(:matcher => /foo/)
  def initialize(args)
    args.each do |key, value|
      send("#{key}=", value)
    end
  end
  
  # Returns whether this MatchMethod is capable of matching the given
  # message.
  def matches?(message)
    !!(message.to_s =~ matcher)
  end
  
  # Calls the method's +proc+ on the given +instance+.
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
# This provides instance-exec-like functionality in Ruby 1.8.
# Originally saw this here:
# http://www.ruby-forum.com/topic/54096
# It appears to have been revised here, so this is a new version:
# http://eigenclass.org/hiki/bounded+space+instance_exec

if RUBY_VERSION.split('.')[1].to_i < 9
  class Object
    module InstanceExecHelper; end
    include InstanceExecHelper
    def instance_exec(*args, &block)
      begin
        old_critical, Thread.critical = Thread.critical, true
        n = 0
        n += 1 while respond_to?(mname="__instance_exec#{n}")
        InstanceExecHelper.module_eval{ define_method(mname, &block) }
      ensure
        Thread.critical = old_critical
      end
      begin
        ret = send(mname, *args)
      ensure
        InstanceExecHelper.module_eval{ remove_method(mname) } rescue nil
      end
      ret
    end
  end
end