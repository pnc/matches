require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe MetaDef do
  before(:each) do
    Hippo.reset_meta_methods
  end
  
  it "should provide a meta_def method on classes" do
    lambda {
      Hippo.class_eval do
        meta_def /foo/
      end
    }.should_not raise_error
  end
  
  it "should call the method if it matches" do
    Hippo.class_eval do
      meta_def /bar/ do
        worked
      end
    end
    
    test = Hippo.new
    test.should_receive(:worked).once
    test.bar
  end
  
  it "should pass in the match groups" do
    Hippo.class_eval do
      meta_def /bar_(\w+)/ do |activity|
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
      
      meta_def /second/ do
        affirm(:second)
      end
    end
    
    test = Hippo.new
    test.should_receive(:affirm).once.with(:first)
    test.should_receive(:affirm).once.with(:second)
    test.first()
    test.second()
  end
end

class Hippo
end