require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe MatchDef do
  before(:each) do
    Hippo.reset_match_methods
    
    class Hippo
      def method_missing(message, *args)
        super
      end
      
      if method_defined?(:match_method_missing)
        undef match_method_missing
      end
    end
  end
  
  describe "when defining instance methods" do
  
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
    
    it "should fall through normally if no match" do
      Hippo.class_eval do
        matches /bar_(\w+)/ do |activity|
          worked(activity)
        end
      end
    
      test = Hippo.new
      test.should_receive(:worked).never
      lambda { test.totally_unmatched }.should raise_error(NoMethodError)
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
  
  describe "when defining class methods" do
    
    it "should call the method if it matches" do
      Hippo.should_receive(:worked).once
      class Hippo
        class << self
          matches /foo/ do
            worked
          end
        end
      end
      
      Hippo.foo
    end
    
    it "should differentiate between class and instance methods" do
      class Hippo
        matches /foo/ do
          worked
        end
        
        class << self
          matches /foo/ do
            failed
          end
        end
      end
      
      herman = Hippo.new
      Hippo.should_receive(:failed).never
      herman.should_receive(:worked).once
      
      herman.foo
    end
  end
end

class Hippo
end

class Rhino
end