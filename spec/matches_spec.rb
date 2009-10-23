require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe MatchDef do
  before(:each) do
    Hippo.reset_meta_methods
  end
  
  it "should provide a matches method on classes" do
    lambda {
      Hippo.class_eval do
        matches /foo/
      end
    }.should_not raise_error
  end
  
  it "should call the method if it matches" do
    Hippo.class_eval do
      matches /bar/ do
        worked
      end
    end
    
    test = Hippo.new
    test.should_receive(:worked).once
    test.bar
  end
  
  it "should pass in the match groups" do
    Hippo.class_eval do
      matches /bar_(\w+)/ do |activity|
        worked(activity)
      end
    end
    
    test = Hippo.new
    test.should_receive(:worked).once.with('fight')
    test.bar_fight()
  end
  
  it "should respect an existing method_missing" do
    Hippo.class_eval do
      def method_missing(message, *args)
        affirm(message)
      end
      
      matches /second/ do
        affirm(:second)
      end
    end
    
    test = Hippo.new
    test.should_receive(:affirm).once.with(:first)
    test.should_receive(:affirm).once.with(:second)
    test.first()
    test.second()
  end
  
  it "should not pollute other classes" do
    Hippo.class_eval do
      matches /second/ do
        throw "Should never be reached"
      end
    end
    
    test = Rhino.new
    lambda { test.second() }.should raise_error
  end
end

class Hippo
end

class Rhino
end